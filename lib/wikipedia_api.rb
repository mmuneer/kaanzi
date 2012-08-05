module WikipediaApi
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
  
end