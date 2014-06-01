
module Cocoadex
  class DocSet
    attr_reader :platform, :version, :name, :description, :path

    def initialize plist_path
      doc = Nokogiri::HTML(IO.read(plist_path).clean_markup)
      @path = plist_path
      @name = plist_value doc, 'CFBundleName'
      @platform = plist_value doc, "DocSetPlatformFamily"
      @version = plist_value doc, "DocSetPlatformVersion"
      @description = plist_value doc, "DocSetDescription"
    end

    def inspect
      "<DocSet #{name} @description=#{description} @path=#{path}>"
    end

    private

    def plist_value doc, key
      key_node = doc.css("dict key").detect do |node|
        node.text == key
      end

      if key_node
        key_node.next.text
      else
        logger.debug "Node not found: #{key}"
        nil
      end
    end
  end
end