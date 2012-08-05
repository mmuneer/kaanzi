# To change this template, choose Tools | Templates
# and open the template in the editor.

module FacebookApi
  
  @facebook_auth = nil
        
  def self.set_facebook_auth(obj)
    @facebook_auth = obj
  end
    
  def self.get_facebook_auth
    return @facebook_auth
  end
  
  def self.login_facebook(param)
    begin
      output = {}
        
      output[:partial] = "redirect_auth"
      output[:data] = "/auth/facebook"

      return output
    rescue
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      
      return output
    end
  end

  def self.post_facebook(param)
    begin
      output = {}
      output[:partial] = "default"
        
      if @facebook_auth.nil?
        output[:message] = "Please login to facebook first. Syntax: login facebook"
        return output
      end
      
      link = param[:attr].slice(URI.regexp(['http']))

      me = FbGraph::User.me(@facebook_auth)
      me.feed!(
        :message => param[:attr],
        :link => link,
        :name => nil,
        :description => nil
      )
      
      output[:message] = "Facebook Status Posted"
      
      return output
    rescue
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output
    end
  end

  def self.get_self(param)
    begin
      output = {}
      output[:partial] = "commands/facebook/login_facebook"
        
      if @facebook_auth.nil?
        output[:message] = "Please login to facebook first. Syntax: login facebook"
        return output
      end
      
      me = FbGraph::User.me(@facebook_auth)
      
      me = me.fetch
      
      output[:data] = me
      output[:message] = "Logged into facebook"
      output[:command_name] = "login facebook"
      return output
    rescue
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output
    end
  end

  def self.find_facebook(param)
    output = {}
    output[:partial] = 'facebook_search'
    output
#    begin
#      output = {}
#      
#      output[:partial] = "default"
#        
#      if @facebook_auth.nil?
#        output[:message] = "Please login to facebook first. Syntax: login facebook"
#        return output
#      end
#
#      me = FbGraph::User.me(@facebook_auth)
#      
#      me.friends.each do 
#        puts "something" 
#      end 
#      
#      
#      output[:message] = "find facebook method"
#      
#      return output
#    rescue
#      output[:message] = "OOPS, Something went wrong. Please try again soon"
#      return output
#    end
  end
  
  def self.list_facebook_friends(param)
    begin
      output = {}
      result = []
        
      output[:partial] = "commands/facebook/simple_list"
        
      if @facebook_auth.nil?
        output[:partial] = "default"
        output[:message] = "Please login to facebook first. Syntax: login facebook"
        return output
      end

      me = FbGraph::User.me(@facebook_auth).fetch
      
      me.friends.each do |friend|
        result.push(friend.name.to_s)
      end
      
      output[:data] = result.sort!()
      
      return output
    rescue
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output
    end
  end
  
  def self.select_person(param)
    begin
      output = {}
      matches = []
      chain_object = []
                
      output[:partial] = "default"
      output[:message] = "No person matches that name"
        
      if @facebook_auth.nil?
        output[:message] = "Please login to facebook first. Syntax: login facebook"
        return output
      end
      
      me = FbGraph::User.me(@facebook_auth).fetch
            
      me.friends.each do |friend|
        if friend.name.to_s.downcase.include? param[:attr].strip.to_s.downcase

          user = FbGraph::User.fetch(friend.identifier, :access_token => @facebook_auth)

          matches.push(user)
          
          chain_object.push(user.identifier)
        end
      end
      
      if matches.length > 1
        output[:data] = matches
        output[:partial] = "commands/facebook/select_specific"
        output[:chain_command] = "selectSpecificPerson"
        output[:chain_object] = chain_object
      end
      
      if matches.length == 1
        output[:data] = matches[0]
        output[:partial] = "commands/facebook/person_info"
      end
        
      return output
    rescue
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output;
    end
  end
  


  def self.select_specific_person(param)
   begin
     output = {}
     matches = []
     chain_object = {}
               
     output[:partial] = "default"
     output[:message] = "Invalid selection"
       
     if @facebook_auth.nil?
       output[:message] = "Please login to facebook first. Syntax: login facebook"
       return output
     end
       
     if param[:data].length >= param[:attr].to_i() and param[:attr].to_i() > 0
       output[:data] = FbGraph::User.fetch(param[:data][param[:attr].to_i() - 1], :access_token => @facebook_auth)
       output[:partial] = "commands/facebook/person_info"
     end
       
     return output
   rescue
     output[:partial] = "default"
     output[:message] = "OOPS, Something went wrong. Please try again soon"
     return output;
   end
 end
  
  def self.post_to_user(param)
    require 'uri'
    begin
      output = {}
      matches = []
      chain_object = {}
      chain_array = []
          
      output[:partial] = "default"
      
      output[:message] = "Please provide more info. Syntax: say hi to [name of person]"
        
      if @facebook_auth.nil?
        output[:message] = "Please login to facebook first. Syntax: login facebook"
        return output
      end
      
      param_array = param[:attr].split(" to ")
      
      username = param_array.last
      message = ""
      
      message_length = param_array.length - 1
      
      param_array.each_with_index do |item, i|
        if i < message_length
          if i > 0
            message = message + " to "
          end
          message = message + item.to_s
        end
      end
      
      #str = "I really love this site: http://www.stackoverflow.com"
      link = message.slice(URI.regexp(['http']))
      #puts str.gsub( url, '<a href="' + url + '">' + url + '</a>' )
      
      if message.blank? or username.blank?
        return output
      else
        me = FbGraph::User.me(@facebook_auth).fetch
                   
        me.friends.each do |friend|
          if friend.name.to_s.downcase.include? username.strip.to_s.downcase
            user = FbGraph::User.fetch(friend.identifier, :access_token => @facebook_auth)
  
            matches.push(user)
                           
            chain_array.push(user.identifier)          
          end
        end
      end
      
      if matches.length > 1
        output[:data] = matches
        output[:partial] = "commands/facebook/post_to_specific"
        chain_object[:data] = chain_array
        chain_object[:param] = message
        output[:chain_command] = "postToSpecificPerson"
        output[:chain_object] = chain_object
      end
         
      if matches.length == 1
        FbGraph::User.new(matches[0].identifier, :access_token => @facebook_auth).feed!( 
          :message => message, 
          :link => link
        )
             
        output[:message] = "Message Posted to #{matches[0].name}"
        output[:partial] = "default"
      end
      
      return output
    rescue
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output;
    end
  end
  
  def self.post_to_specific(param)
    begin
      puts "param inspect: #{param.inspect()}"
      puts "param[:data][:data]: #{param[:data][:data].inspect()}"
      output = {}
      matches = []
      chain_object = {}
               
      output[:partial] = "default"
      output[:message] = "Invalid selection"
       
      if @facebook_auth.nil?
        output[:message] = "Please login to facebook first. Syntax: login facebook"
        return output
      end
       
      if param[:data][:data].length >= param[:attr].to_i() and param[:attr].to_i() > 0
        FbGraph::User.new(param[:data][:data][param[:attr].to_i() - 1], :access_token => @facebook_auth).feed!( 
          :message => param[:data][:param] 
        )
        output[:message] = "Message posted"
      end
       
      return output
    rescue
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output;
    end
  end
  
end
