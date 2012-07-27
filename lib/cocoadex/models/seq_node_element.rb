
module Cocoadex
  class SequentialNodeElement < Element

    def initialize origin, title_node
      @origin = origin
      @name = title_node.text
      parse(title_node)
    end

    def origin
      @origin
    end

    def parse title_node
      prev_node = title_node
      while node = prev_node.next and node.name != "a"
        classes = node.classes
        if classes.include? "abstract"
          @abstract = node.text
        elsif classes.include? "declaration"
          @declaration = node.text
        elsif classes.include? "return_value"
          @return_value = node.text.sub("Return Value","")
        elsif classes.include? "discussion"
          @discussion = node.text.sub("Discussion","")
        elsif classes.include? "availability"
          @availability = node.text.sub("Availability","")
        elsif classes.include? "declaredIn"
          @declared_in = node.text.sub("Declared In","")
        elsif classes.include? "specialConsiderations"
          @considerations = node.text.sub("Special Considerations","")
        else
          handle_node(node)
        end
        prev_node = node
      end
    end

    def handle_node node
      logger.debug("Unhandled #{self.class} property: #{classes} => #{node.text}")
    end
  end
end