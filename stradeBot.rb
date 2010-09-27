#!/usr/local/bin/ruby -w
=begin


=end

require 'rubygems'
require "mysql"
require 'adater_citeseer.rb'

class StradeBot

  # pripojeni k databazi
  @dbh = nil

  @table = "paper"

  # konstruktor
  def initialize
    @table = "paper"
    
    # real_connect(host,user,password,db,port,socket,flags)
    @dbh = Mysql.real_connect("localhost", "strade", "strade", "strade", 3306, "/Applications/MAMP/tmp/mysql/mysql.sock")
    puts "Server version: " + @dbh.get_server_info
  end




  def test
    adapter = Adapter_citeseerx.new
    papers = adapter.get_paper_list(['automata'])

    self.save_to_db(papers)
  end



  #
  # ulozi do databaze klicova slova a udaje
  #
  def save_to_db(items)

    sql = "INSERT INTO #{@table} (id, title, link, author, year) VALUES "

    # zjednoduseni dotazu - spojeni do jednoho
    values = Array.new
    items.each do |item|
      values << "(NULL,
                '"+@dbh.escape_string(item['title'])+"',
                 '"+@dbh.escape_string(item['link'])+"', 
                 '"+@dbh.escape_string(item['author'])+"',
                  '"+@dbh.escape_string(item['year'])+"'
              )"

    end

    sql += values.join(", ")
    @dbh.query(sql)
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
