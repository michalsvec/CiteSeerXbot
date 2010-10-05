#!/usr/local/bin/ruby


require 'net/http'
require 'open-uri'

require "./classes/strade.rb"

# Class with common adapter features
class Adapter < Strade 


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
  def save_paper_file(filename, content)

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


end # /adapter