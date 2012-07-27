
module Cocoadex
  class ConstantGroup < SequentialNodeElement
    TEMPLATE_NAME=:constant_group

    attr_reader :abstract, :declaration,
      :discussion, :declared_in

    def constants
      @constants ||= []
    end

    def handle_node node
      if node.classes.include? "termdef"
        node.css("dt").each do |field_title_node|
          source = "#{@origin} > #{@name}"
          field_name  = field_title_node.css("code").text
          description = field_title_node.next.css("p").map {|p| p.text}.join("\n")
          constants << Constant.new(source,field_name, description)
        end
      elsif node.name == "p" and node.classes.empty?
        @abstract = node.text
      end
    end
  end

  class Constant < Element
    TEMPLATE_NAME=:constant

    attr_reader :description

    def initialize origin, name, description
      @origin = origin
      @name, @description = name, description
    end

    def origin
      @origin
    end
  end
end