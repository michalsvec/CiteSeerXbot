#!/usr/local/bin/ruby

require 'adapter.rb'

class StradeBot


  def test
    var = Adapter.new
    var.download_url("http://michalsvec.cz")
    
  end

end #class stradeBot


bot = StradeBot.new
bot.test




# ulozeni souboru
=begin 
  open("test.html", "wb") { |file|
  file.write(resp.body)
 }
=end
