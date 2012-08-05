module FlickrApi
  
  
  def self::get_most_recent_photo(param)
    puts "This is attr "+ param[:attr]
    output = {}
    if param[:attr] == ""  || param[:attr] != "recent"
      output[:partial] = "default"
      output[:message] = "Please Enter valid command eg. flickr recent"          
      return output
    else
      
    end
    
    begin
      
      output[:partial] = "default"
      result_hash = {}      
      target = "http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=#{Settings.flickr.key}&format=json&nojsoncallback=1&per_page=100&page=1&extras=url_sq,url_m,date_upload,owner_name,path_alias"
      resp_json = HTTPClient.new.get_content(target)
      resp_hash = JSON.parse(resp_json)
      result_hash[:data] = resp_hash
      output[:data] = result_hash
      output[:partial] = "commands/image/flickr/flickr"
      
      return output
    rescue Exception => ex
      puts "ECXCEPTION FOUND: #{ex.message}"
      output[:partial] = "default"
      output[:message] = "Server is busy. Please try again.!"
      return output
    end
    
  end
  
end