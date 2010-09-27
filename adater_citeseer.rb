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
=end

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


  def get_paper_list(keywords)

    output = []

    keywords.each do |keyword|
      puts keyword
      
      #parses array of papers
      data = self.download_url(self.set_url(keyword))
      papers = data.scan(/<ul class="blockhighlight">(.*?)<\/ul>/m).uniq

      # parse necessary data
      papers.each do |item|
        paper = item.to_s
        title = paper.scan(/<em class="title">(.*?)<\/em><\/a>/m)
        link = paper.scan(/<a class="remove doc_details" href="(.*?)">/m)
        author = paper.scan(/<li class="author[\w\s]*">(\S?)\s+/m)
        YAML::dump(author)
        
        #puts "tit: "+title.to_s+"\nlin: "+link.to_s+"\naut: "+author.to_s+"\nyer: \n\n"
        output.push({'title' => title, 'link' => link, 'author' => author})
      end

#        puts paper.respond_to
        
#        paper.scan(/<em class="title">(.*?)<\/em><\/a>/) do |title|
#         puts title
#        end
#        puts paper

#      puts list
#      puts data
      
#      puts YAML::dump(output)
    end

  end #get_paper_list
  
end # class adapter_citeseerx