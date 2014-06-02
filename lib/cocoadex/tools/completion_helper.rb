
module Cocoadex
  class CompletionHelper
    attr_reader :command

    def initialize(command)
      @command = command
    end

    def matches
      scope = Keyword.get_scope(command)

      CompletionHelper.tags.select do |tag|
        tag[0, command.length] == command && Keyword.get_scope(tag) == scope
      end
    end

    def scope_matches
      scope = Keyword.get_scope(command)

      CompletionHelper.tags.select do |tag|
        Keyword.get_scope(tag) == scope
      end
    end

    # Tags file location
    def self.tags_path
      Cocoadex.config_file("tags")
    end

    # Tags loaded from file
    def self.tags
      @tags ||= begin
        if File.exists?(tags_path)
          IO.read(tags_path, :mode => 'rb').split("\n")
        else
          []
        end
      end
    end

    # Clear all tags in file
    def self.clear_tags
      Serializer.write_text(tags_path, "")
    end

    # Build a tags file from existing kewords
    def self.generate_tags!
      logger.info "Generating tags file..."

      datastore = Tokenizer.tokens.sort_by {|k| k.term || "" }
      text = datastore.map {|k| k.term }.join("\n") + "\n"

      # Parse class elements and store tags for scope delimiters
      datastore.select {|k| k.type == :class }.each_slice(100) do |batch|
        Tokenizer.untokenize(batch).each do |klass|
          next unless klass.name

          logger.debug("Tagging #{klass.name} properties")
          text << tagify(
            klass.name,
            (klass.properties+klass.methods.to_a),
            Keyword::CLASS_PROP_DELIM)
          text << tagify(
            klass.name,
            klass.class_methods,
            Keyword::CLASS_METHOD_DELIM)
          text << tagify(
            klass.name,
            klass.instance_methods,
            Keyword::INST_METHOD_DELIM)
        end
      end

      Serializer.write_text(tags_path, text.strip)
    end

    private

    def self.tagify class_name, properties, delimiter
      properties.map {|p|
          "#{class_name}#{delimiter}#{p.name}"
      }.join("\n") + "\n"
    end
  end
end