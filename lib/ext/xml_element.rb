
module Nokogiri
  module XML
    class Element
      def classes
        (self['class'] || "").split(" ")
      end
    end
  end
end