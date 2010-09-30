#!/usr/bin/ruby -w


=begin


=end

require 'rubygems'
require "mysql"
require "time"
require 'adapters/adater_citeseer.rb'

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
    @table = "paper"
    
    # real_connect(host,user,password,db,port,socket,flags)
    @dbh = Mysql.real_connect("localhost", "strade", "strade", "strade", 3306, "/Applications/MAMP/tmp/mysql/mysql.sock")
    puts "Server version: " + @dbh.get_server_info
  end




  def test
    @adapter = Adapter_citeseerx.new
    papers = @adapter.get_paper_list(['automata'])

    self.save_to_db(papers)
  end



  #
  # ulozi do databaze klicova slova a udaje
  #
  def save_to_db(items)

    sql = "INSERT INTO #{@table} (id, title, link, author, year, saved, abstract, origin) VALUES "

    # zjednoduseni dotazu - spojeni do jednoho
    values = Array.new
    time = Time.now.to_i

    items.each { |item|
      values << "(NULL,
                '"+@dbh.escape_string(item['title'])+"',
                '"+@dbh.escape_string(item['link'])+"', 
                '"+@dbh.escape_string(item['author'])+"',
                '"+@dbh.escape_string(item['year'])+"',
                '"+time.to_s+"',
                '"+@dbh.escape_string(item['abstract'])+"',
                '"+@adapter.title+"'
              )"
    }

    sql += values.join(", ")
    @dbh.query(sql)
  end # /save_to_db

end #class stradeBot



bot = StradeBot.new
bot.test


# ulozeni souboru
=begin 
  open("test.html", "wb") { |file|
  file.write(resp.body)
 }
=end
