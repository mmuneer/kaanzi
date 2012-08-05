require 'net/http'

# http://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/

module UriValidator
  def self.valid_url?(value,protocol,format)
    puts "value: #{value.inspect}"
    if value =~ format
	  puts "PASS"
    true
#      begin # check header response
#        case Net::HTTP.get_response(URI.parse(protocol + value))
#          when Net::HTTPSuccess
#            puts "HTTP PASS"
#            true
#          else
#            puts "HTTP FAIL"
#            false
#          end
#      rescue # Recover on DNS failures..
#        puts "HTTP FAIL in rescue"
#         false
#      end
    else
	   puts "FAIL"
	   false
    end
  end
end
