

module SearchApi
  def self.search_generic(param)
    puts "generic search initiated"
    output = {}
      
    bing = RBing.new("EF4B81FE12902BDE881677AB6F1E44215D3DFD20")
    
    rsp = bing.web("ruby")
    puts rsp.web.results[0].title
    
    rsp = bing.instant_answer(param[:attr])
    #msg = rsp.instant_answer.results[0].instant_answer_specific_data.encarta.value
    puts rsp.inspect()
    puts rsp.instant_answer.inspect()
    puts rsp.instant_answer.instant_answer_specific_data.inspect()
                  
    output[:partial] = "default"
    output[:message] = "searching for #{param[:attr]}:"
    
    return output
  end
  
  def self.define_method(param)
    begin
    
      require "duck_duck_go"

      output = {}
      output_array = []
      item = {}
      
      ddg = DuckDuckGo.new
      zci = ddg.zeroclickinfo(param[:attr]) # ZeroClickInfo object
        
      if zci.heading.nil?
        output[:partial] = "default"
        output[:message] = "No Match Found for #{param[:attr]}"
        return output;
      end
      
      output[:partial] = "general_search"

      if zci.type.casecmp("A") == 0
        item[:text] = zci.abstract_text
        item[:image] = zci.image
        output_array.push(item)
      elsif zci.type.casecmp("C") == 0
        zci.related_topics["_"].each do |topic|
          item = {}
          item[:text] = topic.text
          item[:image] = topic.icon.url 
          output_array.push(item)
        end
      elsif zci.type.casecmp("D") == 0
        zci.related_topics["_"].each do |topic|
          item = {}
          item[:text] = topic.text
          item[:image] = topic.icon.url
          output_array.push(item)
        end
      end

      output[:data] = output_array

      return output
    
    rescue Exception => exc
      puts "ECXCEPTION FOUND: #{exc.message}"
      output[:partial] = "default"
      output[:message] = "OOPS, Something went wrong. Please try again soon"
      return output;
    end
  end
  
end