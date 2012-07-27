
module Cocoadex
  class Function < SequentialNodeElement
    attr_reader :abstract, :declaration, :declared_in,
      :availability, :return_value
    TEMPLATE_NAME=:method

    def parameters
      @parameters ||= []
    end

    def discussion
      ""
    end

    def handle_node node
      if node.classes.include? "parameters"
        parse_parameters(node)
      else
        logger.debug("Unhandled function property: #{node.classes} => #{node.text}")
      end
    end

    def type
      "Function"
    end
  end
end