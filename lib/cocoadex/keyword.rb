
require 'fileutils'

module Cocoadex
  class Keyword
    attr_reader :term, :type, :docset, :url
    attr_accessor :fk, :id

    CLASS_METHOD_DELIM = '+'
    INST_METHOD_DELIM  = '-'
    CLASS_PROP_DELIM   = '.'
    SCOPE_CHARS = [CLASS_PROP_DELIM,CLASS_METHOD_DELIM,INST_METHOD_DELIM]

    def self.datastore
      @store ||= []
    end

    # Cache storage location
    def self.data_path
      Cocoadex.config_file("data/store.blob")
    end

    def self.tags_path
      Cocoadex.config_file("tags")
    end

    # Search the cache for matching text
    def self.find text
      if scope = SCOPE_CHARS.detect {|c| text.include? c }
        class_name, term = text.split(scope)
        logger.debug "Searching scope: #{scope}, #{class_name}, #{term}"
        find_with_scope scope, class_name, term
      else
        logger.debug "Searching Keyword datastore (#{datastore.size}): #{text}"
        keys = datastore.select {|k| k.term.start_with? text }
        logger.debug "#{keys.size} keys found"
        if key = keys.detect {|k| k.term == text }
          keys = [key]
          logger.debug "Exact match!"
        end
        untokenize(keys)
      end
    end

    # Find matches for term within a given class
    def self.find_with_scope scope, class_name, term
      if class_key = datastore.detect {|k| k.term == class_name }
        return [] unless class_key.type == :class
        klass = untokenize([class_key]).first
        list  = case scope
          when CLASS_PROP_DELIM
            klass.methods + klass.properties
          when CLASS_METHOD_DELIM
            klass.class_methods
          when INST_METHOD_DELIM
            klass.instance_methods
        end
        list.select {|m| m.name.start_with? term}
      else
        []
      end
    end

    # Are any docsets loaded into the cache?
    def self.loaded?
      File.exists? data_path
    end

    # Read a serialized cache file into an Array
    def self.read
      @store = Serializer.read(data_path)
      logger.debug "Loaded #{datastore.size} tokens"
    end

    # Write a cache Array as a serialized file
    def self.write style
      Serializer.write(data_path, datastore, style)
    end

    def self.tags
      @tags ||= begin
        if File.exists? tags_path
          IO.read(tags_path).split('\n')
        else
          []
        end
      end
    end

    # Build a tags file from existing kewords
    def self.generate_tags!
      text = datastore.map {|k| k.term }.join('\n')
      Serializer.write_text tags_path, text
    end

    # Create Cocoadex model objects for Keyword references
    def self.untokenize keys
      keys.map do |key|
        case key.type
        when :class
          Cocoadex::Class.new(key.url)
        when :ref
          Cocoadex::GenericRef.new(key.url)
        when :data_type, :result_code
          if class_key = datastore.detect {|k| k.id == key.fk}
            ref = Cocoadex::GenericRef.new(class_key.url)
            list = case key.type
              when :result_code then ref.result_codes
              when :data_type   then ref.data_types
            end
            list.detect {|m| m.name == key.term}
          end
        when :method, :property
          if class_key = datastore.detect {|k| k.id == key.fk}
            klass = Cocoadex::Class.new(class_key.url)
            list = key.type == :method ? klass.methods : klass.properties
            list.detect {|m| m.name == key.term}
          end
        end
      end
    end

    # Find all searchable keywords in a class and add to cache
    def self.tokenize_class docset, path, id
      klass = Cocoadex::Class.new(path)
      properties = {
        :method   => klass.methods,
        :property => klass.properties
      }
      tokenize(docset, klass, :class, id, properties)
    end

    def self.tokenize_ref docset, path, id
      ref = Cocoadex::GenericRef.new(path)
      properties = {
        :data_type   => ref.data_types,
        :result_code => ref.result_codes
      }
      tokenize(docset, ref, :ref, id, properties)
    end

    def self.tokenize docset, entity, type, id, properties
      key = Keyword.new(entity.name, type, docset, entity.path)
      key.id = id
      datastore << key

      properties.each do |type, list|
        list.each do |item|
          item_key = Keyword.new(item.name, type, docset, entity.path)
          item_key.fk = id
          datastore << item_key
        end
      end
    end

    def initialize term, type, docset, url
      @term, @type, @docset, @url = term, type, docset, url
    end

    def inspect
      "<Keyword#{type} @term=#{term}>"
    end

    def to_s
      "#{type} => #{term}"
    end
  end
end