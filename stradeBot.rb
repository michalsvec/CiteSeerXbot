#!/usr/local/bin/ruby
=begin
  Instalace nokogiri na MAC OS X
  http://gist.github.com/443160
  
  
  
=end


require 'adater_citeseer.rb'

class StradeBot


  def test
    adapter = Adapter_citeseerx.new
    papers = adapter.get_paper_list(['automata'])
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
