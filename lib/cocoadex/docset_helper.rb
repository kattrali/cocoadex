
module Cocoadex

  # Helper for finding and indexing DocSets
  class DocSetHelper

    ROOT_PATHS = [
      '~/Library/Developer/Documentation/DocSets',
      '~/Library/Developer/Shared/Documentation/DocSets',
      '/Applications/Xcode.app/Contents/Developer/Documentation/DocSets',
      '/Applications/Xcode.app/Contents/Developer/Platforms/*/Developer/Documentation/DocSets'
    ]

    def self.data_path
      Cocoadex.config_file("data/docsets.blob")
    end

    def self.docset_paths
      @paths ||= begin
        ROOT_PATHS.map do |path|
          Dir.glob(File.expand_path(path)+'/*/')
        end.flatten
      end
    end

    def self.search_and_index paths=docset_paths
      docsets = []
      paths.each do |path|
        if docset = Parser.parse(path)
          docsets << docset
        end
      end

      if docsets.size > 0
        Tokenizer.persist
        CompletionHelper.generate_tags!
        write(docsets)
      end
      logger.info "Done! #{docsets.size} DocSet#{docsets.size == 1 ? '':'s'} indexed."
    end

    def indexed_docsets
      @docsets ||= Serializer.read(data_path)
    end

    def self.read
      @docsets = Serializer.read(data_path)
    end

    def self.write docsets
      @docsets = docsets
      Serializer.write_array(data_path, docsets, :overwrite)
    end
  end
end