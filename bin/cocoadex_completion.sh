#!/usr/bin/env sh
#
# cocoadex_completion.sh
#
# Bash completion for Cocoa classes
# Install by adding the following to your .bash_profile:
#
# complete -C /path/to/cocoadex_completion.sh -o default cocoadex

/usr/bin/env ruby <<-EORUBY

require 'cocoadex'

class TagCompletion
  def initialize(command)
    @command = command
  end

  def matches
    completions = tags.select do |tag|
      tag[0, typed.length] == typed
    end

    scope = get_scope(typed)
    completions = completions.select do |tag|
      get_scope(tag) == scope
    end

    completions
  end

  def typed
    @text ||= @command[/\s(.+?)$/, 1] || ''
  end

  def tags
    @tags ||= Cocoadex::Keyword.tags
  end

  def get_scope text
    Cocoadex::Keyword::SCOPE_CHARS.detect {|c| text.include? c}
  end
end

puts TagCompletion.new(ENV["COMP_LINE"]).matches

EORUBY
