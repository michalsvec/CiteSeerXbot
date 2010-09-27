#!/usr/local/bin/ruby


require 'net/http'
require 'open-uri'

# Class with common adapter features
class Adapter 


  def download_url(url)
    open(url).read
  end #download_file
    

end