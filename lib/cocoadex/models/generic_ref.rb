
module Cocoadex
  # A non-class reference document, containing functions,
  # constants, callbacks, result codes, and data types
  class GenericRef < Entity
    attr_reader :specs, :data_types, :overview,
      :result_codes, :const_groups, :functions,
      :callbacks

    def parse doc
      @name  = doc.title.sub("Reference","").strip
      @specs = {}

      parse_specbox(doc)
      parse_overview(doc)
      parse_data_types(doc)
      parse_result_codes(doc)
      parse_constants(doc)
    end

    def constants
      @const_groups.map {|g| g.constants}.flatten
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

    def parse_constants doc
      @const_groups = []
      if section = section_by_title(doc, "Constants")
        section.css("h3.constantGroup").each do |type_title|
          @const_groups << ConstantGroup.new(@name, type_title)
        end
      end
    end

    def parse_result_codes doc
      @result_codes = []
      if section = section_by_title(doc, "Result Codes")
        table = section.css("table").first
        table.css("tr").each do |row|
          if cells = row.css("td") and cells.size > 0
            value = cells[1].text
            description = cells[2].css("p").map {|p| p.text}.join("\n\n")
            @result_codes << ResultCode.new(@name, cells.first.text, value, description)
          end
        end
      end
    end
  end
end