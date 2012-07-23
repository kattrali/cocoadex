
require 'erb'
require 'bri'
require 'cocoadex/docset_helper'
require 'cocoadex/serializer'
require 'cocoadex/version'
require 'cocoadex/templates'
require 'cocoadex/models/docset'
require 'cocoadex/models/element'
require 'cocoadex/models/entity'
require 'cocoadex/models/method'
require 'cocoadex/models/property'
require 'cocoadex/models/class'
require 'cocoadex/parser'
require 'cocoadex/keyword'
require 'ext/nil'
require 'nokogiri'
require 'term/ansicolor'

module Cocoadex

  CONFIG_DIR=File.expand_path("~/.cocoadex")

  # output documentation text for a given search term
  def self.search term, load_first=false
    term = term.strip
    unless term.empty?
      objects = Keyword.find(term)
      if objects.size == 0
        puts "No matches found"
      elsif objects.size == 1 or load_first
        puts objects.first.print
      else
        template = Cocoadex::Templates::MULTIPLE_CHOICES
        puts ERB.new(template, nil, '<>').result(binding)
      end
    end
  end

  # The maximum line width
  def self.width
    Bri.width
  end

  def self.width= width
    Bri.width = width
  end

  # path to a file in the default configuration directory
  def self.config_file subpath
    File.expand_path(File.join(Cocoadex::CONFIG_DIR,subpath))
  end

  # add leading whitespace to lines
  def self.indent text, level=2
    text.split("\n").collect {|row| "#{' '*level}#{row}"}.join("\n" )
  end

  # add leading whitespace to lines, increasing indent after
  # the first line
  def self.trailing_indent text, base_level=2, inside_level=4
    text.split("\n").each_with_index.collect do |row, index|
      level = index == 0 ? base_level : inside_level
      "#{' '*level}#{row}"
    end.join("\n")
  end
end
