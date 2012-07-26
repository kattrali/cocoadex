
module Cocoadex

  class DataType < Element
    TEMPLATE=Cocoadex::Templates::DATATYPE_DESCRIPTION

    attr_reader :abstract, :declaration, :declared_in,
      :discussion, :availability, :fields, :considerations,
      :constants

    def initialize origin, title_node
      @origin = origin
      @name = title_node.text
      @fields = []
      @constants = []
      @abstract = ""
      parse(title_node)
    end

    def origin
      @origin
    end

    def parse title_node
      prev_node = title_node
      next_termdef = ""
      while node = prev_node.next and node.name != "a"
        classes = node['class'].split(" ")
        if classes.include? "abstract"
          @abstract = node.text
        elsif classes.include? "declaration"
          @declaration = node.text
        elsif classes.include? "discussion"
          @discussion = node.text.sub("Discussion","")
        elsif classes.include? "availability"
          @availability = node.text.sub("Availability","")
        elsif classes.include? "declaredIn"
          @declared_in = node.text.sub("Declared In","")
        elsif classes.include? "specialConsiderations"
          @considerations = node.text.sub("Special Considerations","")
        elsif ["Fields","Constants"].include? node.text
          next_termdef = node.text
        elsif classes.include? "termdef" and not next_termdef.empty?
          if list = termdef_to_properties(next_termdef)
            node.css("dt").each do |field_title_node|
              field_name  = field_title_node.css("code").text
              description = field_title_node.next.text
              list << Parameter.new(field_name, description)
            end
            next_termdef = ""
          end
        else
          logger.debug("Unhandled data type property: #{classes} => #{node.text}")
        end
        prev_node = node
      end
    end

    def termdef_to_properties termdef
      case termdef
      when "Fields"
        @fields
      when "Constants"
        @constants
      end
    end
  end
end