
require 'set'

module Cocoadex
  # A model of a Cocoa API class or protocol
  class Class < Entity
    TEMPLATE_NAME=:class

    attr_reader :description, :overview

    def properties
      @properties ||=[]
    end

    def tasks
      @tasks ||= []
    end

    def methods
      @methods ||= ::Set.new
    end

    def class_methods
      methods.select{|m| m.scope == :class }
    end

    def instance_methods
      methods.select{|m| m.scope == :instance }
    end

    def parents
      @parents ||= []
    end

    def type
      "Class"
    end

    def origin
      parents.join(' > ')
    end

    def parse doc
      @name = doc.css('body a').first['title']
      @description = doc.css('meta#description').first['content']
      # @overview = doc.css(".zClassDescription p.abstract").first.text
      @overview = doc.css(".zClassDescription").first.children.map {|n| n.text.sub("Overview","") }
      @parents = doc.css("div.zSharedSpecBoxHeadList").first.css('a').map {|node| node.text}

      parse_properties(doc)
      # parse_tasks(doc)
      parse_methods(doc)
    end

    def parse_methods doc
      [:class, :instance].each do |selector|
        nodes = doc.css("div.#{selector}Method")
        unless nodes.empty?
          methods.merge(nodes.map {|n| Method.new(self, selector, n)})
        end
      end
    end

    def parse_properties doc
      @properties = doc.css("div.propertyObjC").map do |prop|
        Property.new(self, prop)
      end
    end

    def parse_tasks doc
      @tasks = {}
      doc.css('ul.tooltip').each do |list|
        key = list.previous.text
        @tasks[key] = []
        list.css('li span.tooltip').each do |prop|
          @tasks[key] << {
            :name => strip(prop.css('a').first.text),
            :abstract => prop.css('.tooltipicon').first['data-abstract']
          }
        end
      end
      @tasks
    end
  end
end