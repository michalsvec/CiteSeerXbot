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
require 'adapters/adapter.rb'
require 'digest/md5'

class Adapter_citeseerx < Adapter

  # automaticke vygenerovani getteru a setteru pro @url 
  attr_accessor :url
  
  # sort by date desc
  SORTBY = 'date'

  # pager count
  COUNT = 10



  # constructor
  def initialize
    # website url
    @url = "http://citeseerx.ist.psu.edu"
  end



  # vrati URL pro vyhledavani
  # TODO: strankovani
  def set_url(keyword)
    puts "set_url - keyword: "+keyword
    puts "set_url - sortby : "+SORTBY
    url = @url+"/search?q="+keyword+"&sort="+SORTBY+"&start="
    puts "set_url - url    : "+url

    return url
  end



  #
  # ziska vsechny odkazy na strance s vyhledavanim
  # vrati pole slovniku title,link,author
  # 
  # @param array seznam klicovych slov
  def get_paper_list(keywords)
    output = []

    keywords.each do |keyword|
      puts "keyword: "+keyword

      #parses array of papers
      data = Hpricot(self.download_url(self.set_url(keyword)))
      papers = data.search("ul.blockhighlight")

      # parse necessary data
      papers.each do |item|
        #puts item.inner_html # zobrazeni obsahu

        title = item.search("em.title").first.inner_html
        link = item.search("a.doc_details").first.attributes['href']
        # odstraneni prazdnych radku, smrsknuti vicenasobnych mezer a rozdeleni podle html entity pomlcky
        author_and_year = item.search("li.author").first.inner_html.delete("\n").squeeze(" ").split("&#8212;")

        additional_info = self.get_additional_info(link)

        #puts additional_info['down_link']
        downloaded = self.download_paper(additional_info['links'])


        output.push({
          'title' => title,
          'author' => author_and_year[0].strip,
          'link' => downloaded, 
          'year' => author_and_year[1].strip, 
          'abstract' => additional_info['abstract']
        })
      end
    end #each

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
    
    abstract = data.search("#main_content p.para4")
    
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
      puts "trying to download: "+link
      
      # prvne zkontroluji, zda stranka nevraci 404
      parsed_url = URI.parse(link)
      response = Net::HTTP.get_response(parsed_url)
      
      case response
        when Net::HTTPSuccess then
          puts "downloading url: "+link
          data = Net::HTTP.get(URI.parse(link))

          # pokud je soubor z cache - musi se typ souboru dostat z URL - parametr type
          if(link =~ /^#{Regexp.escape(@url)}.*/)
            regex = Regexp.new(/type=([a-z]+)/)
            ext = "."+regex.match(link).to_a[1]
          #jinak se pouzije nazev souboru
          else
            ext = File.extname(link)
          end

          md5 = Digest::MD5.hexdigest(link)
          filename = md5 + ext 
          File.open("files/"+filename, 'w') {|f| f.write(data) }
          break;
        else 
          puts "nelze stahnout: "+link
          next # jinak skoci na dalsi soubor
      end
    end # .each
    
    puts "soubor: "+filename+"---------------------------------------"
    
    if(filename == "")
      return nil
    else 
      return filename
    end
  end # /download_paper
end # class adapter_citeseerx