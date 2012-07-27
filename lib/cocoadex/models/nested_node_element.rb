
module Cocoadex
  # An element of a section where each item
  # is divided into its own div element
  class NestedNodeElement < Element

    def parse_properties node
      @abstract     = node.css(".abstract").first.text
      @declaration  = node.css(".declaration").first.text
      @declared_in  = node.css(".declaredIn code.HeaderFile").first.text
      @discussion   = node.css(".discussion > p").first.text
      @return_value = node.css(".return_value p").first.text
      @return_value = nil if @return_value.empty?
      @availability = node.css(".availability > ul > li").first.text
    end
  end
end