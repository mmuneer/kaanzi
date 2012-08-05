module YelpApi


  def self::search(param)
    output = {}
    search_params = {}
    divider_key = ""  
    divider_aliases = [" near ", " at ", " in ", " location ", " -n " ]
       
#   search_term = TERMS.longest_prefix(param[:attr])
#   term = TERMS[search_term]
        
    divider_aliases.each do |divider_alias|
      if param[:attr].include?divider_alias
        divider_key = divider_alias
        break
      end
    end
    
    if divider_key.blank?
      output[:partial] = "default"
      output[:message] = "Please follow the following Format for Location/Place search. <br/> yelp <business / category> near <address / city / zipcode>"
      return output
    end
     
    url = base_url.clone
    search_term = param[:attr].split(divider_key)
    client = Yelp::Client.new
    business = search_term.first
    location = search_term.last
    search_params[:find_desc] = business
    search_params[:find_loc] = location
    yelp_url = build_url(url,search_params)

    coordinates = Geocoder.coordinates(location)
    request = Yelp::V2::Search::Request::GeoPoint.new(:term => business,:latitude => coordinates.first, :longitude => coordinates.last, :consumer_key => Settings.yelp.consumer_key, :consumer_secret => Settings.yelp.consumer_secret, :token => Settings.yelp.token, :token_secret => Settings.yelp.secret_token)
    businesses = client.search(request)['businesses'].first(5)
    
    output[:data] = businesses
    output[:url] = yelp_url
    output[:partial] = "commands/yelp/yelp"
    output
  end

  protected

  def self::base_url
     'http://www.yelp.com/search'
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
        url
  end

  end
