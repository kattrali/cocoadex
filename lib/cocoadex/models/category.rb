
module Cocoadex
  # A model of a Cocoa API category
  class Category < Class
    TEMPLATE_NAME=:class

    def parse doc
      super
      parse_tasks(doc)
    end
  end
end