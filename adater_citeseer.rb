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


class Adapter_citeseerx < adapter
  
  # constructor
  def initialize    
  end
  
  def get_paper_list(keyword)
    
    
    
  end #get_paper_list
  
end # class adapter_citeseerx