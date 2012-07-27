
module Cocoadex
  class Tokenizer

    # Cache storage location
    def self.data_path
      Cocoadex.config_file("data/store.blob")
    end

    # Tags file location
    def self.tags_path
      Cocoadex.config_file("tags")
    end

    # All indexed searchable keys
    def self.tokens
      @store ||= loaded? ? Serializer.read(data_path) : []
    end

    # Find all tokens with a term identical to a string
    def self.match text
      subset_match(tokens, text)
    end

    # Find all tokens in a subset with a term identical
    # to a string
    def self.subset_match subset, text
      subset.detect {|t| t.term == text }
    end

    # Find all tokens with a term at least starting with
    # a text string. If there is an exact match, return
    # it instead of the entire list
    def self.fuzzy_match text
      subset = tokens.select {|t| t.term.start_with? text }
      if token = subset_match(subset, text)
        [token]
      else
        subset
      end
    end

    # Create a tags file containing all valid token names
    def self.generate_tags_file!
      Serializer.write_text(tags_path, tokens.map {|t|t.term}.join("\n"))
    end

    # Find all searchable keywords in a class and
    # add to cache
    def self.tokenize_class docset, path, id
      klass = Cocoadex::Class.new(path)
      properties = {
        :method   => klass.methods,
        :property => klass.properties
      }
      tokenize(docset, klass, :class, id, properties)
    end

    # Find all searchable keywords in a reference
    # and add to cache
    def self.tokenize_ref docset, path, id
      ref = Cocoadex::GenericRef.new(path)
      properties = {
        :constant    => ref.constants,
        :data_type   => ref.data_types,
        :result_code => ref.result_codes,
        :const_group => ref.const_groups,
        :function    => ref.functions,
        :callback    => ref.callbacks
      }
      tokenize(docset, ref, :ref, id, properties)
    end

    # Create Cocoadex model objects from
    # tokenized keywords references
    def self.untokenize keys
      keys.map do |key|
        case key.type
        when :class
          Cocoadex::Class.new(key.url)
        when :ref
          Cocoadex::GenericRef.new(key.url)
        when :data_type,   :result_code, :function,
             :const_group, :constant, :callback

          if class_key = tokens.detect {|k| k.id == key.fk}
            ref = Cocoadex::GenericRef.new(class_key.url)
            list = case key.type
              when :result_code then ref.result_codes
              when :data_type   then ref.data_types
              when :const_group then ref.const_groups
              when :constant    then ref.constants
              when :function    then ref.functions
              when :callback    then ref.callbacks
            end
            list.detect {|m| m.name == key.term}
          end
        when :method, :property
          if class_key = tokens.detect {|k| k.id == key.fk}
            klass = Cocoadex::Class.new(class_key.url)
            list = key.type == :method ? klass.methods : klass.properties
            list.detect {|m| m.name == key.term}
          end
        end
      end
    end

    private

    # Convert all elements into keyword tokens
    def self.tokenize docset, entity, type, id, properties
      key = Keyword.new(entity.name, type, docset, entity.path)
      key.id = id
      tokens << key

      properties.each do |type, list|
        list.each do |item|
          item_key = Keyword.new(item.name, type, docset, entity.path)
          item_key.fk = id
          tokens << item_key
        end
      end
    end
  end
end