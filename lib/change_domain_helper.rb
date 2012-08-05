module ChangeDomainHelper
  def self.change_domain(param)
    domain = DOMAINS[param[:attr]]
    if domain.blank?
      output = self.no_match(param)
    else
      output = self.send(domain)
    end
    return output
  end
  
  def self.no_match(param)
    output = {}
    output[:partial] = "default"
    output[:message] = "No domain named #{param[:attr]}"
    return output
  end
  
  def self.home_domain
    output = {}
    output[:partial] = "default"
    output[:message] = "You are now in home domain"
    output[:domain] = ""
    return output
  end
  
  def self.twitter_domain
    output = {}
    output[:partial] = "default"
    output[:message] = "You are now in Twitter Domain"
    output[:domain] = "twitter"
    return output
  end
end