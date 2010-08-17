#!/usr/local/bin/ruby

require 'adater_citeseer.rb'

class StradeBot


  def test
    adapter = Adapter_citeseerx.new
    papers = adapter.get_paper_list(['automata', 'biometrics'])
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
