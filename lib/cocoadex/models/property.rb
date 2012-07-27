
module Cocoadex
  # A Cocoa API class property
  class Property < Element
    attr_reader :abstract, :declaration, :discussion,
      :availability, :parent

    def initialize parent_class, node
      @parent = parent_class
      @name   = node.css("h3.method_property").first.text
      logger.debug("Adding property: #{@name}")

      if abs = node.css(".abstract") and abs.length > 0
        @abstract = abs.first.text
      end

      if decl = node.css(".declaration") and decl.length > 0
        @declaration = decl.first.text
      end

      if disc = node.css(".discussion > p") and disc.length > 0
        @discussion = disc.first.text
      end

      if ava_nodes = node.css(".availability > ul > li") and ava_nodes.size > 0
        @availability = ava_nodes.first.text
      end
    end

    def origin
      parent.to_s
    end

    def type
      "Property"
    end
  end
end