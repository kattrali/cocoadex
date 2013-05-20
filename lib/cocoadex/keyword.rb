
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
      Cocoadex::KeywordStore.find_keywords text
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
  end
end
