
module Cocoadex
  # A Cocoa API class property
  class Property < NestedNodeElement
    TEMPLATE_NAME=:property

    attr_reader :abstract, :declaration, :discussion,
      :availability, :parent

    def initialize parent_class, node
      @parent = parent_class
      @name   = node.css("h3.method_property").first.text

      parse_properties(node)
    end

    def origin
      parent.to_s
    end

    def type
      "Property"
    end
  end
end