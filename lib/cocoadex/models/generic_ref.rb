
module Cocoadex
  # A non-class reference document containing functions,
  # constants, callbacks, result codes, and data types
  class GenericRef < Entity
    attr_reader :specs, :data_types, :overview,
      :result_codes, :const_groups, :functions,
      :callbacks
    TEMPLATE_NAME=:generic_ref

    def parse doc
      @name  = doc.title.sub("Reference","").strip
      @specs = {}

      parse_specbox(doc)
      parse_overview(doc)
      parse_data_types(doc)
      parse_result_codes(doc)
      parse_constants(doc)
      parse_functions(doc)
      parse_callbacks(doc)
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

    def parse_callbacks doc
      @callbacks = []
      parse_section(doc, @callbacks, "Callbacks", Callback)
    end

    def parse_functions doc
      @functions = []
      parse_section(doc, @functions, "Functions", Function)
    end

    def parse_data_types doc
      @data_types = []
      parse_section(doc, @data_types, "Data Types", DataType)
    end

    def parse_constants doc
      @const_groups = []
      parse_section(doc, @const_groups, "Constants",ConstantGroup)
    end

    def parse_section doc, list, title, klass
      if section = section_by_title(doc, title)
        section.css("h3").each do |type_title|
          list << klass.new(@name, type_title)
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