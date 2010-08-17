#!/usr/local/bin/ruby


require 'net/http'


# Class with common adapter features
class Adapter 


  def download_url(url)
    
    puts url
    Net::HTTP.start(url) { |http|

      resp = http.get("/")
      dump_variable(resp.body)
    }
    
    
  end #download_file
    

end