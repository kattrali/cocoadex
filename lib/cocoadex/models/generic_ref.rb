
module Cocoadex
  # A non-class reference document, usually containing
  # functions, constants, and data types
  class GenericRef < Entity
    TEMPLATE=Cocoadex::Templates::REF_DESCRIPTION

    attr_reader :specs, :data_types, :overview

    def parse doc
      @name  = doc.title
      @specs = {}

      parse_specbox(doc)
      parse_overview(doc)
      parse_data_types(doc)
    end

    def parse_overview doc
      if section = section_by_title(doc, "Overview")
        @overview = section.text.sub("Overview","")
      else
        @overview = ""
      end
    end

    def parse_specbox doc
      specbox = doc.css(".specbox")
      return if specbox.to_a.empty?
      specbox.first.css("tr").each do |row|
        title = row.css("td").first.css("strong").text
        value = row.css("td").to_a[1].text.strip
        @specs[title] = value
      end
    end

    def parse_data_types doc
      @data_types = []
      if section = section_by_title(doc, "Data Types")
        section.css("h3.jump").each do |dtype_title|
          @data_types << DataType.new(@name, dtype_title)
        end
      end
    end
  end
end