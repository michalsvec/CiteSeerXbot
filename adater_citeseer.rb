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
    puts "set_url: "+keyword
    puts "set_url: "+SORTBY

    url = "http://citeseerx.ist.psu.edu/search?q="+keyword+"&sort="+SORTBY+"&start="
    puts "set_url:"+url
    puts "set_url: END\n"

    return url
  end


  def get_paper_list(keywords)

    keywords.each do |keyword|
      puts keyword

      data = self.download_url(self.set_url(keyword))
#      puts data
    end

  end #get_paper_list
  
end # class adapter_citeseerx