#!/usr/bin/env sh
#
# cocoadex_completion.sh
#
# Bash completion for Cocoa classes
# Install by copying this file (such as to "$HOME/bin") and
# adding the following to your .bash_profile:
#
# complete -C /path/to/cocoadex_completion.sh -o default cocoadex

/usr/bin/env ruby <<-EORUBY

require 'cocoadex'

prefix = ENV["COMP_LINE"][/\s(.+?)$/,1]

puts Cocoadex::CompletionHelper.new(prefix).matches

EORUBY