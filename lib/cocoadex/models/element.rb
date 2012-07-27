
module Cocoadex
  # A searchable element stored in the cache
  class Element
    include Comparable
    include Bri::Templates::Helpers

    attr_reader :name

    def to_s
      name
    end

    def print
      template_name = self.class.const_get("TEMPLATE_NAME")
      path = Cocoadex.view_path(template_name)
      template = IO.read(path, :mode => 'rb')
      ERB.new(template, nil, '<>').result(binding)
    end

    def <=> other
      name <=> other.name if other.respond_to? :name
    end

    def origin
      raise "#{self.class}#origin is not defined"
    end

    def type
      raise "#{self.class}#type is not defined"
    end

    def parse_parameters node
      node.css("dt").each do |param|
        name_nodes = param.css("em")
        if name_nodes.size > 0
          name = param.css("em").first.text
          description = param.next.css("p").first.text
          parameters << Parameter.new(name, description)
        end
      end
    end
  end
end