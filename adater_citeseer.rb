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
require 'adapter.rb'

class Adapter_citeseerx < Adapter

  # sort by date desc
  SORTBY = 'date'

  # pager count
  COUNT = 10

  
  # constructor
  def initialize    


  end


  def set_url(keyword)
    puts "set_url - keyword: "+keyword
    puts "set_url - sortby : "+SORTBY

    url = "http://citeseerx.ist.psu.edu/search?q="+keyword+"&sort="+SORTBY+"&start="
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

        output.push({'title' => title, 'link' => link, 'author' => author_and_year[0], 'year' => author_and_year[1]})
      end
    end #each

    return output
  end #get_paper_list

end # class adapter_citeseerx