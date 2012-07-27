
module Cocoadex
  # An element of a section where each item
  # is divided by anchor tags
  class SequentialNodeElement < Element
    Abstract     = ->(node) { node.classes.include? "abstract"     }
    Declaration  = ->(node) { node.classes.include? "declaration"  }
    ReturnValue  = ->(node) { node.classes.include? "return_value" }
    Discussion   = ->(node) { node.classes.include? "discussion"   }
    Availability = ->(node) { node.classes.include? "availability" }
    DeclaredIn   = ->(node) { node.classes.include? "declaredIn"   }
    Special      = ->(node) { node.classes.include? "specialConsiderations" }

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
        case node
        when Abstract
          @abstract = node.text
        when Declaration
          @declaration = node.text
        when Availability
          @availability = node.text.sub("Availability","")
        when ReturnValue
          @return_value = node.text.sub("Return Value","")
        when Discussion
          @discussion = node.text.sub("Discussion","")
        when DeclaredIn
          @declared_in = node.text.sub("Declared In","")
        when Special
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