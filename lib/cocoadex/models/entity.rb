module Cocoadex
  # A top level element, roughly equivalent to one
  # page of documentation
  class Entity < Element
    attr_reader :path

    def initialize path
      @path    = path
      text     = clean(IO.read(path, :mode => 'rb'))
      document = Nokogiri::HTML(text)
      parse(document)
    end

    # Remove leading and trailing whitespace from lines, while
    # stripping HTML tags
    def clean text
      text.gsub(/(\n|\t|\r)/, ' ').gsub(/>\s*</, '><').squeeze(' ')
    end

    def strip text
      text.gsub("&#xA0;&#xA0;","")
    end

    def section_by_title doc, title
      doc.css("section").to_a.detect {|s| s.css("h2.jump").text == title }
    end
  end
end