
module Cocoadex
  class Parameter
    include Comparable

    attr_reader :name, :description

    def initialize name, description
      @name, @description = name, description
    end

    def to_s
      "#{name} - #{description}"
    end

    def <=> other
      name <=> other.name if other.respond_to? :name
    end
  end
end