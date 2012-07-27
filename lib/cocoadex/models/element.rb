
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
      template_name = self.class.name.split("::").last.underscore
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
  end
end