# To change this template, choose Tools | Templates
# and open the template in the editor.

module NonSocialApi

  
    def self.eatMethod(param)
     output = {}
     output[:message] = "I'm not hungry..."
     output[:partial] = "default"
    return output
    end
    
    def self.mridul(param)
      output = {}
      output[:message] = "oi son"
      output[:partial] = "default"
      return output
    end

    def self.invalid_method(param)
      output = {}
      output[:message] = "Bad command or filename..."
     output[:partial] = "default"
    return output
   end
  
   def self.track_package(param)
     output = {}
     output[:partial] = "track_package"
     return output
   end
   
   def self.track_flight(param)
     output = {}
     output[:partial] ="track_flight"
     return output
   end

    def self.launchSite(param,format)
      output = {}
      protocol = nil
      if(param[:attr].start_with?('http'))
        protocol = 'http://'
      else
        protocol = 'https://'
      end
      puts "NonSocialApi::launchSite:"
      uri = param[:attr].gsub(/(http|https):\/\//,'')
      puts "URI after gsub: #{uri}"
      if UriValidator::valid_url?(uri.strip,protocol,format)
        puts "NonSocialApi::launchSite: valid url"
        output[:partial] = "launch_page"
        output[:data] = protocol + uri.strip
        output[:message] = 'Page opened'
		  else
        puts "NonSocialApi::launchSite: INVALID url"
        output[:partial] = "default"
        output[:data] = nil
        output[:message] = 'Could not open page'
      end
	  return output
  end
end