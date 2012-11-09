
require 'sqlite3'

module Cocoadex
  class Database
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

    def self.find_keywords text
      query = "SELECT DISTINCT #{ROWS} FROM keyword WHERE term LIKE ?"
      params = [text+"%"]
      if scope = Keyword.scope_name(text)
        query << " AND scope = ?"
        params << scope
      else
        query << " AND scope IS NULL"
      end
      elements = []
      keystore.execute(query, params) do |row|
        keyword = Keyword.new(row[1], row[2].to_sym, row[4],row[5])
        keyword.id = row.first
        keyword.fk = row.last
        elements << keyword.to_element
      end
      elements
    end
  end
end