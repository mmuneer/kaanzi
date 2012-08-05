module DirectionApi
  
  def self::find_direction(param)
    output = {}
    search_params = {}
    search_term = param[:attr].split(" to ")
    destination = search_term.last
    if search_term.first.starts_with?("from ")
      origin = search_term.first.split("from ").last
    else
      origin = search_term.first
    end
    search_params[:origin] = origin
    search_params[:destination] = destination
    request = build_url(base_url,search_params)
    url     = URI.escape(request)
    uri     = URI.parse(url)
    http    = Net::HTTP.new(uri.host, uri.port)
    result  = handle_response(request, http.request(Net::HTTP::Get.new(uri.request_uri)))
    output[:message] = "direction sent"
    output[:partial] = "commands/direction/direction"
    output[:data] = result
    return output
  end
  
  def self::traffic(param)
    output = {}
    output[:message] = "traffic info sent"
    output[:partial] = "traffic"
    return output
  end
  
  protected

  def self::base_url
     'http://maps.googleapis.com/maps/api/directions/json'
 end
 
  def self::build_url (url, params)
        unless params.nil?
          url << '?'
          param_count = 0
          params.each do |key, value|
            value = value.strip
            next if value.nil?
            url << '&' if (param_count > 0)
            url << "#{CGI.escape(key.to_s)}=#{CGI.escape(value.gsub(/W/,"+"))}"
            param_count += 1
          end
        end
        url += "&sensor=false"
  end
  
  def self::handle_response(request, response)
    hsh = {}
    array = []
    #parse result if result received properly
    if response.is_a?(Net::HTTPSuccess)
      #parse the json
      parse = JSON.parse(response.body)
      #check if google went well
      if parse["status"] == "OK"
       
        route = parse["routes"].first["legs"].first

        hsh[:distance] = route["distance"]["text"]
        hsh[:duration] = route["duration"]["text"]
        hsh[:start_address] = route["start_address"]
        hsh[:end_address] = route["end_address"]
#        hsh[:start_location][:lat] = route["start_location"]["lat"]
#        hsh[:start_location][:lng] = route["start_location"]["lng"]
#        hsh[:end_location][:lat] = route["end_location"]["lat"]
#        hsh[:end_location][:lng] = route["end_location"]["lng"]
       
        route["steps"].each do |step|
          array << { 
                     :distance    => step["distance"]["text"], 
                     :duration    => step["duration"]["text"],
                     :instruction => step["html_instructions"].html_safe
                    }
        end
        hsh[:steps] = array
        return hsh
      else #status != OK
        puts "The address you passed seems invalid, status was: #{parse["status"]}.
        Request was: #{request}"
        
      end #end parse status
      
    else #if not http success
     puts "The request sent to google was invalid (not http success): #{request}.
      Response was: #{response}"           
    end #end resp test
  end
end