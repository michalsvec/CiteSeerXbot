#!/usr/bin/ruby -w


=begin
  trida pro praci s jednotlivym dokumentem
=end


class Document
  
  attr_accessor :title, :authors, :published, :abstract, :year, :filename, :filetype

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
    sql = "SELECT * FROM "+@table+" WHERE `title` = '"+$dbh.escape_string(@title)+"' AND `published` = '"+$dbh.escape_string(@year)+"'"
    result = $dbh.query(sql)
    
    if result.num_rows == 0 then
      return true
    else
      return false
    end
  end



  #
  # ulozi udaje dokumentu do databaze
  def save
    if (@filename.nil?)
      return false
    end

    sql = "INSERT INTO #{@table} (id, title, published, created, origin, abstract, filename, filetype) 
           VALUES "

    time = Time.now.to_i

    sql << "(NULL,
              '"+$dbh.escape_string(@title)+"',
              '"+$dbh.escape_string(@year)+"', 
              '"+time.to_s+"',
              '"+@adapter_title+"',
              '"+$dbh.escape_string(@abstract)+"',
              '"+$dbh.escape_string(@filename)+"',
              '"+$dbh.escape_string(@filetype)+"'
            )"
    # ulozeni dokumentu
    $dbh.query(sql)
    doc_id = $dbh.insert_id().to_s

    # ulozeni autoru a sparovani s dokumentem
    # 1] vytahnuti ID autoru, pokud uz v databazi jsou
    authors_sql = Array.new();
    @authors.each do |author|
      authors_sql << "'"+$dbh.escape_string(author)+"'"
    end

    sql = "SELECT DISTINCT (name), id FROM authors WHERE `name` IN ("+authors_sql.join(",")+") "
    db_authors = $dbh.query(sql)

    author_ids = Array.new()  # pole ID autoru, ktere pak se pak sparuji s dokumentem
    
    # dostupne autory neukladam znovu do databaze
    # pouze si ulozim jejich ID, abych je pak sparoval s dokumentem
    # row[0] = jmeno autra, row[1] = id autora
    while row = db_authors.fetch_row do
      author_ids << row[1]
      puts "autor uz existuje: "+row[0]
      @authors.delete(row[0])  # odstraneni z pole autoru, aby se neukladali znovu
    end
    db_authors.free # trocha cistoty

    # ulozeni autoru do databaze
    @authors.each do |author|
      $dbh.query("INSERT INTO authors (name) VALUES('"+$dbh.escape_string(author)+"') ON DUPLICATE KEY UPDATE name = '"+$dbh.escape_string(author)+"'")

      # v pripade, ze uz v databazi existoval - v @authors se nachazel dvakrat
      if($dbh.insert_id() != 0)
        author_ids << $dbh.insert_id()
        puts "novy autor: "+author
      end
    end

    # vytvorim dvojice klic - klic a pak ulozim do mapovaci tabulky
    author_ids_sql = Array.new()
    author_ids.each do |id|
      author_ids_sql  << "(#{doc_id}, #{id})"
    end

    $dbh.query("INSERT INTO authors2documents (document_id, author_id) VALUES "+author_ids_sql.join(","))

    return true
  end # /save



end