#!/usr/local/bin/ruby


require 'net/http'
require 'open-uri'

# Class with common adapter features
class Adapter 


  def download_url(url)
    
    # nelze tak stahovat celou url ale jen url kde je pouze nazev domeny
#    Net::HTTP.start(url) { |http|
#      http.get("/")
#    }

    open(url).read
  end #download_file
    

end