
module Cocoadex
  # A model of a method in a Cocoa class
  class Method < Element
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
      logger.debug("parsing #{@type} method #{@name}")

      @abstract = node.css(".abstract").first.text
      @declaration = node.css(".declaration").first.text

      decl_nodes = node.css(".declaredIn code.HeaderFile")
      @declared_in = decl_nodes.first.text if decl_nodes.size > 0

      discussion_node = node.css(".discussion > p")
      @discussion = discussion_node.first.text if discussion_node.length > 0

      return_nodes = node.css(".return_value p")
      @return_value = return_nodes.first.text if return_nodes.size > 0

      ava_nodes = node.css(".availability > ul > li")
      @availability = ava_nodes.first.text if ava_nodes.size > 0

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