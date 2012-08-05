module WeatherApi
  def self.get_weather(param)
    require 'net/http'    
    begin
      output = {}
      output[:partial] = "default"
      output[:message] = "get_weather method executed"
      key = Settings.weather.key
    
      divider_aliases = [" near ", " at ", " in ", " location ", " -n " ]
      divider_key = ""
      
      divider_aliases.each do |divider_alias|
        if param[:attr].include?divider_alias
          divider_key = divider_alias
          break
        end
      end
    
      if divider_key.blank?
        location = param[:attr]
      else
        location = param[:attr].split(divider_key).last
      end
    
      coordinates = Geocoder.coordinates(location)
      
      if coordinates.nil?
        geo_search_ip = Geocoder.search(param[:remote_ip])
        coords = "#{geo_search_ip[0].latitude},#{geo_search_ip[0].longitude}"
        location = geo_search_ip[0].city
      else
        coords = "#{coordinates.first},#{coordinates.last}"
      end
      
      uri = URI('http://free.worldweatheronline.com/feed/weather.ashx')
      
      uri_params = { :q => coords, :format => "json", :num_of_days => 4, :key => key }
      
      uri.query = URI.encode_www_form(uri_params)
      
      resp_json = Net::HTTP.get(uri)
      
      resp_hash = JSON.parse(resp_json)
            
      result_hash = {}
      result_hash[:data] = resp_hash["data"]
      result_hash[:location] = location
    
      output[:data] = result_hash
      output[:partial] = "commands/weather/weather_info"
  
      return output
    rescue Exception => exc
      puts "ECXCEPTION FOUND: #{exc.message}"
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output
    end
  end
end