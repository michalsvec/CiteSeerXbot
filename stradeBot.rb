#!/usr/bin/ruby -w


=begin


=end

require 'rubygems'
require "time"

require "./classes/strade.rb"
require 'classes/adapters/adater_citeseer.rb'

class StradeBot < Strade

  # objekt adapteru
  @adapter = nil

  # pocet stranek, ktere stahovat
  PAGES = 10



  def test
    @adapter = Adapter_citeseerx.new
    papers = @adapter.get_paper_list(['automata'])

    self.save_to_db(papers)
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
