#!/usr/bin/ruby -w


=begin
  trida pro praci s jednotlivym dokumentem
=end

require "yaml"
require "./classes/strade.rb"




class Document < Strade
  
  attr_accessor :title, :author, :published, :abstract, :year, :filename, :filetype

  @adapter_title = ""


  def initialize(adapter_title)
    super() # vola metodu se stejnym nazvem v rodici
    @adapter_title = adapter_title
    @table = "documents"
  end



  #
  #zjisti, zda uz soubor existuje v databazi nebo ne
  #
  # pokud uz takovy soubor existuje, vrati false
  # pokud jeste ne, vrati true
  def unique?
    sql = "SELECT * FROM "+@table+" WHERE `title` = '"+@dbh.escape_string(@title)+"' AND `published` = '"+@dbh.escape_string(@year)+"'"
    result = @dbh.query(sql)
    
    if result.num_rows == 0 then
      return true
    else
      return false
    end
  end



  #
  # ulozi udaje dokumentu do databaze
  def save
    sql = "INSERT INTO #{@table} (id, title, published, created, origin, abstract, filename, filetype) 
           VALUES "

    # zjednoduseni dotazu - spojeni do jednoho
    time = Time.now.to_i

    sql << "(NULL,
              '"+@dbh.escape_string(@title)+"',
              '"+@dbh.escape_string(@year)+"', 
              '"+time.to_s+"',
              '"+@adapter_title+"',
              '"+@dbh.escape_string(@abstract)+"',
              '"+@dbh.escape_string(@filename)+"',
              '"+@dbh.escape_string(@filetype)+"'
            )"
              
    @dbh.query(sql)
  end
end