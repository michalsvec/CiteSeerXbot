#!/usr/bin/ruby -w


=begin


=end

require 'rubygems'
require "time"
require "mysql"
require "yaml"

require 'classes/adapters/adater_citeseer.rb'

#
# printovaci shorcut
def d(data)
  puts YAML::dump(data)
end

#
# pripojeni k databazi
# real_connect(host,user,password,db,port,socket,flags)
$dbh = Mysql.init
$dbh.options(Mysql::SET_CHARSET_NAME, 'utf8')
$dbh.real_connect("localhost", "strade", "strade", "strade", 3306, "/Applications/MAMP/tmp/mysql/mysql.sock")
$dbh.query("SET NAMES utf8")
#puts "Server version: " + @dbh.get_server_info



class StradeBot

  # objekt adapteru
  @adapter = nil




  def test
    @adapter = Adapter_citeseerx.new
    papers = @adapter.get_paper_list(['automata'])
      
    puts "USPESNE DOKONCENO! HURA"
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
