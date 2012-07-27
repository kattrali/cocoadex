
require 'fileutils'

module Cocoadex
  class Keyword
    attr_reader :term, :type, :docset, :url
    attr_accessor :fk, :id

    CLASS_METHOD_DELIM = '+'
    INST_METHOD_DELIM  = '-'
    CLASS_PROP_DELIM   = '.'
    SCOPE_CHARS = [CLASS_PROP_DELIM,CLASS_METHOD_DELIM,INST_METHOD_DELIM]

    # Search the cache for matching text
    def self.find text
      logger.debug "Searching tokens for #{text}"
      if scope = SCOPE_CHARS.detect {|c| text.include? c }
        class_name, term = text.split(scope)
        find_with_scope(scope, class_name, term)
      else
        keys = Tokenizer.fuzzy_match(text)
        keys.map {|k| k.to_element }
      end
    end

    def initialize term, type, docset, url
      @term, @type, @docset, @url = term, type, docset, url
    end

    def to_element
      Tokenizer.untokenize([self])
    end

    def inspect
      "<Keyword#{type} @term=#{term}>"
    end

    def to_s
      "#{type} => #{term}"
    end

    private

    # Find matches for term within a given class
    def self.find_with_scope scope, class_name, term
      if class_key = Tokenizer.match(class_name)
        return [] unless class_key.type == :class
        klass = class_key.to_element
        list  = case scope
          when CLASS_PROP_DELIM
            klass.methods + klass.properties
          when CLASS_METHOD_DELIM
            klass.class_methods
          when INST_METHOD_DELIM
            klass.instance_methods
        end
        list.select {|m| m.name.start_with? term}
      else
        []
      end
    end

    def self.tags
      @tags ||= begin
        if File.exists? tags_path
          IO.read(tags_path).split('\n')
        else
          []
        end
      end
    end

    # Build a tags file from existing kewords
    def self.generate_tags!
      text = datastore.map {|k| k.term }.join('\n')
      Serializer.write_text tags_path, text
    end
  end
end