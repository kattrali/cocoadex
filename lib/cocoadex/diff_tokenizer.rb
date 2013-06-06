
module Cocoadex

  class DiffTokenizer < Tokenizer

    def self.tokens
      @store ||= []
    end

    def self.loaded?
      true
    end
  end
end