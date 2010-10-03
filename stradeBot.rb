#!/usr/bin/ruby -w


=begin


=end

require 'rubygems'
require "mysql"
require "time"

require 'classes/adapters/adater_citeseer.rb'

class StradeBot

  # pripojeni k databazi
  @dbh = nil

  # nazev tabulky v dtb
  @table = "paper"

  # objekt adapteru
  @adapter = nil

  # pocet stranek, ktere stahovat
  PAGES = 10



  # konstruktor
  def initialize
    @table = "documents"
    
    # real_connect(host,user,password,db,port,socket,flags)
    @dbh = Mysql.real_connect("localhost", "strade", "strade", "strade", 3306, "/Applications/MAMP/tmp/mysql/mysql.sock")
    puts "Server version: " + @dbh.get_server_info
  end




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
