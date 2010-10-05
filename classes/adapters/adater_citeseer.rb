#!/usr/local/bin/ruby

=begin
	link na vyhledavani 
	-------------------
	priklad: http://citeseerx.ist.psu.edu/search?q=automata&sort=rlv&start=10
	parametry: 
		q - hledana fraze
		sort - podle ceho radit?
			cite - citace
			date - rok, sestupne
			ascdate - rok, vzestupne
			recent - aktualnost
		start - strankovani (strankuje po 10)
		
		
		Hpricot
    -------
    http://github.com/hpricot/hpricot/wiki
		
=end

require 'rubygems'
require "yaml"
require "hpricot"
require "open-uri"
require 'net/http'
require 'digest/md5'

require './classes/adapter.rb'
require './classes/document.rb'


class Adapter_citeseerx < Adapter

  # automaticke vygenerovani getteru a setteru pro @url 
  attr_accessor :url, :title
  
  # sort by date desc
  SORTBY = 'date'

  # pager count
  COUNT = 10

  #kolik stranek stahovat?
  LIMIT = 10



  # constructor
  def initialize
    # website url
    @url = "http://citeseerx.ist.psu.edu"
    @title = "citeseerx"
  end



  # vrati URL pro vyhledavani
  # TODO: strankovani
  def set_url(keyword, page)
    puts "set_url - keyword: "+keyword
    puts "set_url - sortby : "+SORTBY
    url = @url+"/search?q="+keyword+"&sort="+SORTBY+"&start="+(page*COUNT).to_s
    puts "set_url - url    : "+url
    puts ""

    return url
  end



  #
  # ziska vsechny odkazy na strance s vyhledavanim
  # vrati pole slovniku title,link,author
  # 
  # @param array seznam klicovych slov
  def get_paper_list(keywords)
    output = []
    page = 0

    keywords.each do |keyword|
      puts "keyword: "+keyword

      LIMIT.times do |page|
        puts "page: "+page.to_s

        #parses array of papers
        data = Hpricot(self.download_url(self.set_url(keyword, page)))
        papers = data.search("ul.blockhighlight")
  
        # parse necessary data
        papers.each do |item|
          
  
          title = item.search("em.title").first.inner_html
          link = item.search("a.doc_details").first.attributes['href']
          # odstraneni prazdnych radku, smrsknuti vicenasobnych mezer a rozdeleni podle html entity pomlcky
          author_and_year = item.search("li.author").first.inner_html.delete("\n").squeeze(" ").split("&#8212;")
          additional_info = self.get_additional_info(link)
 
          puts "Dokument:\t"+title

          # vytvoreni tridy pro dokument
          doc = Document.new(@title)
          # gsub stripne html tagy
          doc.title = title.strip.gsub(/<\/?[^>]*>/, "")
          doc.year = author_and_year[1].strip 
          doc.abstract = additional_info['abstract']
          # rozdeleni jmen autoru - citeseerx ma rozdeleno mezerou a carkou
          doc.authors = self.parse_authors(author_and_year[0].strip.sub(/^by /, ""))
            
          # kontrola, zda dokument ukladat nebo ne
          if doc.unique? then
            puts "unikatni"
            downloaded = self.download_paper(additional_info['links'])
            doc.filename = downloaded
            doc.filetype = 'application/pdf' 
            if(doc.save() === false)
              puts "Chyba pri ukladani dokumentu!"
            end
          else
            puts "NEunikatni"
          end
          
          puts "\n\n"
        end #papers.each
      end #LIMIT.times
    end #keywords.each

    return output
  end #get_paper_list



  #
  # ziska ze stranky s podrobnostni abstrakt a link na stazeni souboru
  # vraci hash pole 
  #   abstract string text abstraktu
  #   links    array  pole odkazu na soubory - posledni odkaz je na nakesovanou verzi ze citeseerx
  def get_additional_info(link)
    link = @url+link
    data = Hpricot(self.download_url(link))
    
    abstract = data.search("#main_content p.para4").inner_html

    
    download_links = Array.new
    data.search("#downloads a").each do |link|
      href = link.attributes['href']

      # pokud je prvni znak "/" kod 47 (h z http ma 104) - jedna se o odkaz na cachovanou verzi ze citeseerx
      if(href[0] == 47)
        href = @url+href
      end

      download_links << href 
    end #/search

    return {'abstract' => abstract, 'links' => download_links}
  end # /get_download_url



  #
  # stahne soubor z webu a vrati cestu k nemu na disku
  # @param  array  pole odkazu na soubor
  # @return string cesta k souboru na disku 
  def download_paper(links)
    
    filename = "";

    links.each do |link|
      puts "trying: \t"+link
      
      # prvne zkontroluji, zda stranka nevraci 404
      parsed_url = URI.parse(link)
      response = Net::HTTP.get_response(parsed_url)
      
      case response
        when Net::HTTPSuccess then
          puts "downloading"
          data = Net::HTTP.get(URI.parse(link))

          # pokud je soubor z cache - musi se typ souboru dostat z URL - parametr type
          if(link =~ /^#{Regexp.escape(@url)}.*/)
            regex = Regexp.new(/type=([a-z]+)/)
            ext = "."+regex.match(link).to_a[1]
          #jinak se pouzije nazev souboru
          else
            ext = File.extname(link)
          end

          hash = self.get_hashed_filename(link)
          filename = hash + ext 

          # ulozi soubor do prislusne slozky
          self.save_paper_file(filename, data)
          break;

        else 
          puts "nelze stahnout!!!1"
          next # jinak skoci na dalsi soubor
      end
    end # .each

    puts "soubor: \t"+filename

    if(filename == "")
      return nil
    else 
      return filename
    end
  end # /download_paper



  #
  # parsne autory a vrati v poli, aby bylo mozne je ulozit domapovaci tabulky
  # @param string seznam autoru oddeleny v pripade citeseerx carkou
  def parse_authors(author)
    authors = author.split(", ")
    authors.each do |author|
      author.strip
    end
    return authors
  end # /parse_authors



end # class adapter_citeseerx