class Command < ActiveRecord::Base
  include  TwitterApi
  include  FacebookApi
  include  NonSocialApi
  include  HistoryApi
  include  SearchApi
  include  WeatherApi
  include  CalculateApi
  include  DictionaryApi
  include  FlickrApi
  #acts_as_taggable_on :tags
  has_many :histories, :dependent => :destroy
  has_many :users, :through => :histories
  # Validates a command provided by user
  # Params: Command String (e.g :"Open www.facebook.com")
  # Output: A comma separated String containing the function name to execute and the last command before params start
  # TODO: Need to write tests
  def self.validate(str)
    #['read','twitter, 'from','dip']
    output = {}
    output[:cmd] = "invalidMethod"
    position = nil
    possible_position = nil
    possible_key = ""
    possible_command = ""
    command_array = str.downcase.split()
    tmp_hsh = CMD_RULES
    if command_array.size > 0
      command_array.each do |element|
        if tmp_hsh.key?(element)
          if is_str?(tmp_hsh,element)
            cmd = tmp_hsh[element]
            output[:cmd] = cmd
            output[:key] = element
            position = command_array.index(element)
        break
          else
            tmp_hsh = tmp_hsh[element]
            if possible_position.blank?
              if tmp_hsh.key?(element)
                if is_str?(tmp_hsh, element)
                  possible_command = tmp_hsh[element]
                  possible_key = element
                  possible_position = command_array.index(element)
                end
              end
            end
          end
        end
      end
    
      if output[:cmd].casecmp("invalidMethod") == 0
        unless possible_command.blank?
        output[:cmd] = possible_command
        output[:key] = possible_key
      end
    end

    end
    return output
  end
  
  def self.setParams(command,key,user,remote_ip)
    begin
      output = {}
      
      unless user.nil?      
        output[:user] = user
      end
      
      output[:key] = key
      start_ss = command.downcase.index(key) + key.length
      attr = command[start_ss, command.length] unless start_ss.nil?
      if attr.casecmp(command) == 0
        output[:attr] = "none"
      else 
        output[:attr] = attr.strip
      end
      output[:remote_ip] = remote_ip
      return output
    rescue
      return nil
    end
  end
 
  def self.set_yelp_params(business,location,user)
    unless user.nil?
      output[:user] = user
    end
    output[:attr] = business + " near " + location
    return output    
  end
  
  def self.setChainCommandParams(param, data, user, remote_ip)
    begin
      output = {}
      unless user.nil?
        output[:user] = user
      end
      output[:attr] = param
      output[:data] = data
      output[:remote_ip] = remote_ip
      
      return output
    rescue
      return nil
    end
  end
  
  def self.exec_command(methodName, attr)
    output = self.send(methodName, attr)
    output
  end

  private
  def self.is_str?(hsh,key)
    ("String".casecmp(hsh[key].class().to_s()) == 0) ? true : false
  end

  #### Twitter Services ####
  
  # Getter Method for twitter_auth of TwitterAPI Object
  def self.get_twitter_auth
    TwitterApi::get_twitter_auth
  end
  
  # Setter Method for twitter_auth of TwitterAPI Object
  def self.set_twitter_auth(obj)
    TwitterApi::set_twitter_auth(obj)
  end
  
  # Login Twitter Method (example cmd: login twitter)
  
  def self.loginTwitter(param)
    TwitterApi::login_twitter(param)
  end
  
  def self.twitterGetSelf(param)
    TwitterApi::get_self(param)
  end
  
  # search Twitter Status Method(example cmd: search twitter election from:BarackObama) 
  def self.searchTwitter(param)
    output = TwitterApi::search_twitter(param)
  end
  
  # Twitter Stream Output Method (example cmd: read twitter stream)
  def self.showTwitterStream(param)
    output = TwitterApi::show_twitter_stream(param)
  end
  
  # Post Twitter Status Method (example cmd: post twitter status "test status")
  def self.postTwitter(param)
    output = TwitterApi::post_twitter(param)
  end
  
  
  
  #### Facebook Services ####
  
  # Getter Method for facebook_auth of FacebookAPI Object
  def self.get_facebook_auth
    FacebookApi::get_facebook_auth
  end
  
  # Setter Method for facebook_auth of FacebookApi Object
  def self.set_facebook_auth(obj)
    FacebookApi::set_facebook_auth(obj)
  end
  
  def self.loginFacebook(param)
    output = FacebookApi::login_facebook(param)
  end
  
  def self.facebookGetSelf(param)
    output = FacebookApi::get_self(param)
  end
  
  def self.findFacebook(param)
    output = FacebookApi::find_facebook(param)
    output
  end

  def self.postFacebook(param)
    output = FacebookApi::post_facebook(param)
  end
  
  def self.listFacebookFriends(param)
    output = FacebookApi::list_facebook_friends(param)
  end
  
  def self.selectPerson(param)
    output = FacebookApi::select_person(param)
  end
  
  def self.selectSpecificPerson(param)
    output = FacebookApi::select_specific_person(param)
  end
  
  #### Search Services ####
  def self.defineMethod(param)
    output = SearchApi::define_method(param)
  end
  
  def self.defaultSearch(param)
    output = self.bingSearch(param)
    return output
  end
  
  def self.bingSearch(param)
    output = {}
    
    key = Settings.bing.appid
    
    uri = URI('http://api.bing.net/json.aspx?')
    #URI.encode_www_form("q" => "ruby", "lang" => "en")
    #http://api.bing.net/json.aspx?Appid=<AppID>&query=sushi&sources=web&web.count=40&web.offset=41
      
    uri_params = { :Appid => key, :sources => "web", :query => param[:attr]}
      
    uri.query = URI.encode_www_form("Appid" => key, "sources" => "web", "query" => param[:attr], "web.count" => "5")
      
    resp_json = Net::HTTP.get(uri)
      
    resp_hash = JSON.parse(resp_json)
    
    puts "bing response: #{resp_hash.inspect()}"
    
    output[:data] = resp_hash
    output[:partial] = "commands/bing/bing_default"
    output[:message] = "bing search hit"
    return output
  end
  
  def self.wiki(param)
    output = {}
    
    uri = URI('http://en.wikipedia.org/w/api.php?')

    uri.query = URI.encode_www_form("action" => "parse", "prop" => "text", "format" => "json", "page" => param[:attr], "redirects" => "")
      
    resp_json = Net::HTTP.get(uri)
    
    resp_hash = JSON.parse(resp_json)
    
    result = resp_hash['parse']['text']['*']
    result = result.gsub /\shref=\"/, ' target=\"blank\" \0http://www.wikipedia.org'
    
    image_array = result.scan(/\/\/upload.wikimedia.org\/wikipedia\/.*\.jpg/)

    #action=parse&format=jsonfm&page=ram&redirects
    output[:data] = result
    output[:images] = image_array
    output[:partial] = "commands/wiki/wiki_main"

    return output
  end    
  
  #### history Services ####
   #TODO: Write better regex to match queries like history 2 days ago and so forth
    def self.history(param)
    if param[:attr].nil?
       output = HistoryApi::history(param)
    elsif param[:attr].include?('days') or param[:attr].include?('day')
        output = HistoryApi::history_days_ago(param)
    elsif param[:attr].include?('weeks')or param[:attr].include?('week')
        output = HistoryApi::history_weeks_ago(param)
    elsif param[:attr].include?('months')or param[:attr].include?('month')
        output = HistoryApi::history_months_ago(param)
    elsif param[:attr].include?('hours')or param[:attr].include?('hour')
      output = HistoryApi::history_hours_ago(param)
    else
     output = HistoryApi::history(param)
    end
  end

 #### bookmark Services ####

    def self.bookmark(param)
      output = BookmarkApi::bookmarks(param)
#       output = "Showing bookmarks"
    end
  
  #### Aggregated Services ####
  
  def self.say(param)
    FacebookApi::post_to_user(param)
  end
  
  def self.postToSpecificPerson(param)
    FacebookApi::post_to_specific(param)
  end
  
  #### Other Services ####
  
  def self.eatMethod(param)
     output = NonSocialApi::eatMethod(param)
  end
  
  def self.launchSite(param)
    output = NonSocialApi::launchSite(param,URI_FORMAT)
  end
  
  def self.invalidMethod(param)
    output = NonSocialApi::invalid_method(param)
  end
  
  def self.track_package(param)
    output = NonSocialApi::track_package(param)
    return output
  end
  
  def self.track_flight(param)
    output = NonSocialApi::track_flight(param)
    return output
  end
  
  def self.insufficientParams(param)
    output = "Insuffcient params"
  end
  
  def self.getWeather(param)
    output = WeatherApi::get_weather(param)
    return output
  end

  def self.yelp(param)
    output = YelpApi::search(param)
    output
  end
  
  def self.yelpEnhance(param)
    param[:attr] = param[:key] + " " + param[:attr]
    output = YelpApi::search(param)
    output
  end
  
  def self.direction(param)
    output = DirectionApi:: find_direction(param)
    output
  end
  
  def self.traffic(param)
    output = DirectionApi:: traffic(param)
    output
  end
  
  def self.find_gmail(param)
    output = GmailApi:: search(param)
    output
  end
  
  def self.calculate(param)
    output = CalculateApi::calculate(param)
    return output
  end
  
  def self.dictionaryLookup(param)
    output = DictionaryApi::dictionary_lookup(param)
    return output
  end
  def self.mostRecentPhotos(param)
    output = FlickrApi::get_most_recent_photo(param)
    return output
  end

  def self.helpCommand(param)
    output = {}
    output[:data] = "help"
    output[:partial] = "help"
    return output
  end
  
end
