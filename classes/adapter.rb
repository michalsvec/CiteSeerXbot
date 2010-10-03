#!/usr/local/bin/ruby


require 'net/http'
require 'open-uri'

# Class with common adapter features
class Adapter 


  #
  # stahne URL a vrati obsah dokumentu
  # @param  string url souboru
  # @return string obsah souboru
  def download_url(url)
    open(url).read
  end #download_file



  #
  # vrati zahashovany nazev souboru
  # @param  string
  # @return string zahashovany nazev 
  def get_hashed_filename(filename)
    Digest::MD5.hexdigest(filename)
  end



  #
  # vrati nazev prvni urovne adresare pro ulozeni souboru
  def get_1st_dir_lvl(filename)
    filename.slice(0,4)
  end



  #
  # vrati nazev druhe urovne adresare pro ulozeni souboru
  def get_2nd_dir_lvl(filename)
    filename.slice(5,4)
  end



  #
  # ulozi soubor do spravne slozky
  # ukladaji se do slozek - "prvni 4 znaky z hashe"/"druhe 4 znaky z hashe"/soubor.pdf
  def save_paper(filename, content)

    dir1 = self.get_1st_dir_lvl(filename)
    dir2 = self.get_2nd_dir_lvl(filename)

    unless File.directory?('files/'+dir1) then  # unless = if !expr
      Dir.mkdir('files/'+dir1)
    end

    unless File.directory?('files/'+dir1+'/'+dir2) then  # unless = if !expr
      Dir.mkdir('files/'+dir1+'/'+dir2)
    end

    File.open("files/"+dir1+'/'+dir2+'/'+filename, 'w') {|f| f.write(content) }
  end #/ save_paper



  #
  # ulozi do databaze klicova slova a udaje dokumentu
  # volano z trid jednotlivych adapteru po kontrole, zda uz soubor neexistuje
  #
  def save_to_db(item)

    sql = "INSERT INTO #{@table} (id, title, published, created, origin, abstract, filename, filetype) 
           VALUES "

    # zjednoduseni dotazu - spojeni do jednoho
    time = Time.now.to_i

    values = "(NULL,
              '"+@dbh.escape_string(item['title'])+"',
              '"+@dbh.escape_string(item['year'])+"', 
              '"+time.to_s+"',
              '"+@adapter.title+"',
              '"+@dbh.escape_string(item['abstract'])+"',
              '"+@dbh.escape_string(item['filename'])+"',
              '"+@dbh.escape_string(item['filetype'])+"'
            )"
    @dbh.query(sql)
  end # /save_to_db



end