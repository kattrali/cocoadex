module Bri
  module Templates
    module Helpers
      def wrap text
        Bri::Renderer.wrap_row(text, Cocoadex.width)
      end

      def h3 text
        Term::ANSIColor::blue + text + Term::ANSIColor::reset + "\n"
      end

      def inline_title title, value, alignment=0
        length = alignment - title.length
        buffer = length > 0 ? " "*length : ""
        Term::ANSIColor::bold + title + ": " + Term::ANSIColor::reset + "#{buffer}#{value}\n"
      end
      module_function :h3, :inline_title, :wrap
    end
  end
end
