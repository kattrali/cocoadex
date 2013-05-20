
require 'sqlite3'

module Cocoadex
  class KeywordStore
    ROWS = "id, term, type, scope, docset, url, parent_fk"

    def self.keystore
      @db ||= SQLite3::Database.new(keystore_path)
    end

    def self.keystore_path
      File.join(Cocoadex::CONFIG_DIR,"keystore.db")
    end

    def self.migrate
      # create keyword table ->
      keystore.execute("CREATE TABLE IF NOT EXISTS keyword"+
        "(id INTEGER, term TEXT, type TEXT, scope TEXT, docset TEXT, url TEXT, parent_fk INTEGER)")

      # create keyword index on term name
      keystore.execute("CREATE INDEX IF NOT EXISTS keyword_term ON keyword ('term' ASC)")
    end

    def self.persist_keywords keywords
      migrate
      keystore.transaction do |db|
        keywords.each do |keyword|
          params = [keyword.id, keyword.term, keyword.type.to_s, Keyword.scope_name(keyword.term), keyword.docset, keyword.url, keyword.fk]
          # logger.info "Inserting: #{keyword.term}: #{params}"
          db.execute("INSERT INTO keyword(#{ROWS}) VALUES(?,?,?,?,?,?,?)", params)
        end
      end
    end

    def self.loaded?
      keystore.execute("select * from keyword").size > 0
    end

    def self.find_by_id id
      query = "SELECT DISTINCT #{ROWS} FROM keyword WHERE id = ?"
      params = [id]
      keywords = []
      keystore.execute(query, params) do |row|
        keywords << row_to_keyword(row)
      end
      if keywords.size > 0
        return keywords.first
      else
        return nil
      end
    end

    def self.count
      query = "SELECT COUNT(*) FROM keyword"
      return keystore.execute(query).first.first.to_i
    end

    def self.find_keywords text, max=50, offset=0
      query = "SELECT DISTINCT #{ROWS} FROM keyword WHERE term >= ? and term < ?"
      params = []
      if scope = Keyword.get_scope(text)
        parent, text = text.split(scope)
        params << text
        params << text.succ
        scope_name = Keyword::SCOPE_NAMES[scope]
        # query  << " AND scope = ?"
        # params << scope_name.downcase
        query  << " AND parent_fk in (select id from keyword where term = ? and id is not null)"
        params << parent
      else
        query << " AND scope IS NULL"
        params << text
        params << text.succ
        query << " AND scope IS NULL"
      end
      query << " LIMIT ? OFFSET ?"
      params << max
      params << offset
      elements = []
      logger.debug "Running query: #{query} with parameters: #{params}"
      keystore.execute(query, params) do |row|
        elements << row_to_keyword(row).to_element
      end
      elements.compact
    end

    def self.find_by_type type
      query = "SELECT DISTINCT #{ROWS} FROM keyword WHERE type = ?"
      params = [type.to_s]
      keystore.execute(query, params).map do |row|
        row_to_keyword(row)
      end
    end

    private

    def self.row_to_keyword row
      keyword = Keyword.new(row[1], row[2].to_sym, row[4],row[5])
      keyword.id = row.first
      keyword.fk = row.last
      keyword
    end
  end
end