
module Cocoadex
  class ResultCode < Element
    attr_reader :value, :description

    def initialize origin, name, value, description
      @origin = origin
      @name, @value, @description = name, value, description
    end

    def origin
      @origin
    end
  end
end