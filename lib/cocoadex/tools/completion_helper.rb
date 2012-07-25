
module Cocoadex
  class CompletionHelper
    attr_reader :command

    def initialize(command)
      @command = command
    end

    def matches
      scope = get_scope(command)

      tags.select do |tag|
        tag[0, command.length] == command && get_scope(tag) == scope
      end
    end

    def scope_matches
      scope = get_scope(command)

      tags.select do |tag|
        get_scope(tag) == scope
      end
    end

    def tags
      Cocoadex::Keyword.tags
    end

    def get_scope text
      Cocoadex::Keyword::SCOPE_CHARS.detect {|c| text.include? c}
    end
  end
end