
module Cocoadex

  class DataType < SequentialNodeElement
    TEMPLATE_NAME=:data_type

    class Field < Parameter;end

    attr_reader :abstract, :declaration, :declared_in,
      :discussion, :availability, :considerations
    attr_accessor :next_termdef

    def fields
      @fields ||= []
    end

    def constants
      @constants ||= []
    end

    def origin
      @origin
    end

    def handle_node node
      if ["Fields","Constants"].include? node.text
        next_termdef = node.text
      elsif node.classes.include? "termdef" and not next_termdef.nil?
        if list = termdef_to_properties(next_termdef)
          node.css("dt").each do |field_title_node|
            field_name  = field_title_node.css("code").text
            description = field_title_node.next.text
            list << Field.new(field_name, description)
          end
          next_termdef = ""
        end
      end
    end

    def termdef_to_properties termdef
      case termdef
      when "Fields" then fields
      when "Constants" then constants
      end
    end
  end
end