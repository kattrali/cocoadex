
module Cocoadex
  # A model of a method in a Cocoa class
  class Method < NestedNodeElement
    TEMPLATE_NAME=:method

    attr_reader :abstract, :declaration, :discussion,
      :declared_in, :availability, :parameters,
      :return_value, :scope, :parent

    def parameters
      @parameters ||= []
    end

    def initialize parent_class, type, node
      @parent = parent_class
      @scope  = type
      @name   = node.css("h3.#{type}Method").first.text

      parse_properties(node)
      parse_parameters(node.css(".parameters").first)
    end

    def type
      "#{scope.to_s.capitalize} Method"
    end

    def origin
      parent.to_s
    end
  end
end