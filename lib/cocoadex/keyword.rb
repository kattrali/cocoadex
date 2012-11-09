
require 'fileutils'

module Cocoadex
  class Keyword
    include Comparable

    attr_reader :term, :type, :docset, :url
    attr_accessor :fk, :id

    CLASS_METHOD_DELIM = '+'
    INST_METHOD_DELIM  = '-'
    CLASS_PROP_DELIM   = '.'
    SCOPE_CHARS = [CLASS_PROP_DELIM,CLASS_METHOD_DELIM,INST_METHOD_DELIM]
    SCOPE_NAMES = {
      CLASS_PROP_DELIM => "PROPERTY",
      CLASS_METHOD_DELIM => "CLASS_METHOD",
      INST_METHOD_DELIM => "INSTANCE_METHOD"
    }

    def <=>(other_key)
      term <=> other_key.term
    end

    # Search the cache for matching text
    def self.find text
      logger.debug "Searching tokens for #{text}"
      Cocoadex::Database.find_keywords text
    end

    def self.get_scope text
      SCOPE_CHARS.detect {|c| text.include? c}
    end

    def self.scope_name text
      Keyword::SCOPE_NAMES[Keyword.get_scope(text)]
    end

    def initialize term, type, docset, url
      @term, @type, @docset, @url = term, type, docset, url
    end

    def to_element
      Tokenizer.untokenize([self]).first
    end

    def inspect
      "<Keyword:#{type} @term=\"#{term}\">"
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
  end
end
