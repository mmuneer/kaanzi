class CommandsController < ApplicationController
  before_filter :set_tutorial
  
  def new 
    @current_tutorial = @tutorial.get_current_tutorial
    @tutorial.save
    @current_domain ||= session[:domain] || ''
    @request = Command.new
  end

  def index
    command = params[:command][:name]
    
    Input.create(:text => command)

    remote_ip = request.remote_ip
    
    domain ||= session[:domain] || ''

    #set facebook and twitter auths    
    set_auths
    #validating command format 
    validated_cmd = Command.validate(command, domain) 
    #checking if the command has been chained
    if validated_cmd[:cmd].casecmp("invalidMethod") == 0 && !session[:chain_command].nil?
      params = Command.setChainCommandParams(command, session[:chain_obj], current_user, remote_ip)
      @results = Command.exec_command(session[:chain_command],params)
    else
      params = Command.setParams(command, validated_cmd[:key], current_user, remote_ip)
      @results = Command.exec_command(validated_cmd[:cmd],params)
      @results[:command_name] = command
      #adding the command to history
      unless !add_to_history?(validated_cmd[:cmd])
        add_to_history(validated_cmd[:key],params[:attr])
      end 
    end
    set_chain_command_session(@results)
    @results[:command_exec_time] = Time.now
    
    unless @results[:domain].nil?
      session[:domain] = @results[:domain]
    end  
    
    @current_domain ||= session[:domain] || ''
    
    @tutorial.adjust_tutorial(validated_cmd[:key])
    
    @current_tutorial = @tutorial.get_current_tutorial
    
    @tutorial.save
    
    respond_to do |format|
      format.js {render :partial => 'index'}
    end
    
   end
   
  def set_tutorial
    @tutorial ||= get_tutorial_instance_from_session || get_tutorial_instance_from_cookie || Tutorial.create(:completed => '')
    session[:tutorial_id] = @tutorial.id
    cookies['tutorial_id'] = {:value => @tutorial.id, :expires => 30.days.from_now}
  end

  def add_to_history?(str)
    case str
      when "invalidMethod"
        false
      when "history"
        false
      when "bookmark"
        false
      else
        true
    end
  end
  
  def add_to_history(cmd_name, attr)
    
    unless current_user.nil?
      cmd = Command.create(:name => cmd_name,:params => attr)
      history = History.create(:user_id => current_user.id, :command_id => cmd.id)
    end
    #cmd.tag_list << cmd.name
    #cmd.save
  end
  
  def set_auths
    #setting sessions for twitter
    if session[:twitter_auth]
      Command.set_twitter_auth(session[:twitter_auth])
    end
     #setting sessions for facebook
    if session[:facebook_auth]
      Command.set_facebook_auth(session[:facebook_auth])
    end

  end

  def set_chain_command_session(result)
    if  result[:chain_command].nil?
      session[:chain_command] = nil
    else
      session[:chain_command] = result[:chain_command]
      session[:chain_obj] = result[:chain_object]
    end  
  end

  
  def provider_callback
    omniauth = request.env["omniauth.auth"]
      
    case omniauth['provider']
    when 'facebook'
      session[:facebook_auth] = omniauth['credentials']['token']
      Command.set_facebook_auth(session[:facebook_auth])
      @results = Command.exec_command("facebookGetSelf","")
      
    when 'twitter'
      twitter_auth = {
        :atoken => omniauth['credentials']['token'],
        :asecret => omniauth['credentials']['secret']
      }

      session[:twitter_auth] = twitter_auth
      Command.set_twitter_auth(session[:twitter_auth])
      @results = Command.exec_command("twitterGetSelf","")
      
    end
  
    @results[:command_exec_time] = Time.now

    #redirect_to new_command_url
  end
  
  def get_tutorial_instance_from_session
    tutorial = Tutorial.find(session[:tutorial_id]) unless session[:tutorial_id].nil?
  end
  
  def get_tutorial_instance_from_cookie
    unless cookies['tutorial_id'].nil?
      tutorial = Tutorial.find(cookies['tutorial_id'])
    tutorial.setup_return_visit_settings
    tutorial.save
    end
  return tutorial
  end

end