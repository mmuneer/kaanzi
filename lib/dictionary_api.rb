module DictionaryApi
  def self.dictionary_lookup(param)
    begin
      output = {}
      output[:partial] = "commands/dictionary/dictionary"
        
      key = Settings.wordnik.key
                
      uri = URI("http://api.wordnik.com/v4/word.json/#{param[:attr]}/definitions")
      
      uri_params = { :api_key => key }
      
      uri.query = URI.encode_www_form(uri_params)
      
      resp_json = Net::HTTP.get(uri)
      
      resp_hash = JSON.parse(resp_json)
      
      output[:data] = resp_hash
      
      if resp_hash.first.blank?
        output[:partial] = "default"
        output[:message] = "No definition found for #{param[:attr]}"
      end  
      
      return output
    rescue
      puts "MCMCMC could not retrieve word"
      output[:partial] = "default"
      output[:message] = "No definition found for #{param[:attr]}"
      return output
    end
  end
end