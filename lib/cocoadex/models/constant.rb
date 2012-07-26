
module Cocoadex
  class ConstantGroup < Element
    TEMPLATE=Cocoadex::Templates::CONSTANT_GROUP_DESCRIPTION
    attr_reader :abstract, :declaration, :constants,
      :discussion, :declared_in

    def initialize origin, title_node
      @origin = origin
      @name = title_node.text
      @constants = []
      parse(title_node)
    end

    def origin
      @origin
    end

    def parse title_node
      prev_node = title_node
      next_termdef = ""
      while node = prev_node.next and node.name != "a"
        classes = (node['class'] || "").split(" ")

        if classes.include? "declaration"
          @declaration = node.text
        elsif classes.include? "discussion"
          @discussion = node.text.sub("Discussion","")
        elsif classes.include? "declaredIn"
          @declared_in = node.text.sub("Declared In","")
        elsif classes.include? "termdef"
          node.css("dt").each do |field_title_node|
            source = "#{@origin} > #{@name}"
            field_name  = field_title_node.css("code").text
            description = field_title_node.next.css("p").map {|p| p.text}.join("\n")
            @constants << Constant.new(source,field_name, description)
          end
        elsif classes.include? "abstract" or node.name == "p"
          @abstract = node.text
        else
          logger.debug("Unhandled data type property: #{classes} => #{node.text}")
        end
        prev_node = node
      end
    end
  end

  class Constant < Element
    TEMPLATE=Cocoadex::Templates::CONSTANT_DESCRIPTION

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