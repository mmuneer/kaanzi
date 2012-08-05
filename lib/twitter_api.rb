# To change this template, choose Tools | Templates
# and open the template in the editor.

module TwitterApi

  @twitter_auth = nil
      
  def self.set_twitter_auth(obj)
    @twitter_auth = obj
  end
  
  def self.get_twitter_auth
    return @twitter_auth
  end
  
  def self.login_twitter(param)
    begin
      output = {}
        
      output[:partial] = "redirect_auth"
      output[:data] = "/auth/twitter"

      return output
	  rescue
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
	    
      return output
	  end
  end
  
  def self.get_self(param)
    begin
      output = {}
      
      Twitter.configure do |config|
        config.consumer_key       = Settings.twitter.consumer_key
        config.consumer_secret    = Settings.twitter.consumer_secret
        config.oauth_token        = @twitter_auth[:atoken]
        config.oauth_token_secret = @twitter_auth[:asecret]
      end
      
      client = Twitter::Client.new
      current_user = client.current_user.attrs.attrs
      
      output[:partial] = "commands/twitter/login_twitter"
      output[:data] = current_user
      output[:command_name] = "login twitter"
      
      return output
    rescue
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      
      return output
    end
  end
  
  def self.post_twitter(param)
    begin
      output = {}
      output[:partial] = "default"
        
	    if @twitter_auth.nil?
        output[:message] = "Please login to twitter first. Syntax: login twitter username"
	      return output
	    end 
	
	    Twitter.configure do |config|
	      config.consumer_key       = Settings.twitter.consumer_key
	      config.consumer_secret    = Settings.twitter.consumer_secret
	      config.oauth_token        = @twitter_auth[:atoken]
	      config.oauth_token_secret = @twitter_auth[:asecret]
	    end

	    client = Twitter::Client.new
	    client.update(param[:attr])
      
      output[:message] = "Twitter Status Posted"
      
	    return output
	  rescue
      output[:message] = "OOPS, Something went wrong. Please try again soon"
	    return output
	  end
  end
  
  def self.show_twitter_stream(param)
    begin
      output = {}
      result = []
        
      if @twitter_auth.nil?
        output[:partial] = "default"
        output[:message] = "Please login to twitter first. Syntax: login twitter username"
	      return output
	    end
	     
	    Twitter.configure do |config|
	      config.consumer_key       = Settings.twitter.consumer_key
	      config.consumer_secret    = Settings.twitter.consumer_secret
	      config.oauth_token        = @twitter_auth[:atoken]
	      config.oauth_token_secret = @twitter_auth[:asecret]
	    end
	    
	    stream_array = Twitter.home_timeline

	    stream_array.each do |r|
        tweet = {}
	      tweet[:user] = "#{r.user.screen_name}"
        tweet[:profile_image_url] = "#{r.user.profile_image_url}"
        tweet[:text] = "#{r.text}"
        result.push(tweet)
      end
            
      output[:partial] = "commands/twitter/twitter_stream"
      output[:data] = result
	    
      return output
	  rescue
      output[:partial] = "default"
      output[:message] = 'OOPS, Something went wrong. Please try again soon'
	    return output
	  end
  end
  
  def self.search_twitter(param)
    begin
      output = {}
      result = []
      
      Twitter.search(param[:attr], :rpp => 20, :result_type => "recent").results.map do |status|
        tweet = {}
        tweet[:user] = "#{status.from_user}"
        tweet[:profile_image_url] = "#{status.profile_image_url}"
        tweet[:text] = "#{status.text}"
        tweet[:time] = "#{status.created_at}"
        result.push(tweet)
      end
      
      output[:partial] = "commands/twitter/twitter_stream"
      output[:data] = result
      
      return output
      
    rescue
      output[:partial] = "default"
      output[:message] = "Could not find any match for #{param[:attr]}"
      return output
    end
    
  end

  def self.find_twitter(param)
    output = {}
    result = []
          
    if param[:attr].nil?
      output[:partial] = "default"
      output[:message] = "Please Enter valid query <br/> example: read twitter from somebody to somebody containing something <br/> atleast one of these keywords (from, to, containing) should be used"          
      return output
    end
    
    search = Twitter.Search        
    search.containing("\\s")
    search.per_page(3)
    
    param_array = param[:attr].split(" ")
    flag = "invalid"
    param_array.each_index do |n|
      if n < (param_array[n].length - 1)
        if param_array[n].casecmp("containing") == 0			
          search.containing(param_array[n + 1])
          flag = "valid"
        end
        if param_array[n].casecmp("to") == 0
          search.to(param_array[n + 1])
          flag = "valid"
        end
        if param_array[n].casecmp("from") == 0
          search.from(param_array[n + 1])
          flag = "valid"
        end
      end
    end
      
    if flag == "valid"
      search.result_type("recent").per_page(3).each do |r|
        tweet = {}
        tweet[:user] = "#{r.from_user}"
        tweet[:text] = "#{r.text}"
        result.push(tweet)  
      end
      
      Twitter.search("to:justinbieber marry me", :rpp => 3, :result_type => "recent").map do |status|
        "#{status.from_user}: #{status.text}"
      end
    end
    
    output[:partial] = "twitter_stream"
    output[:data] = result
    
    return output
  end
  
end
