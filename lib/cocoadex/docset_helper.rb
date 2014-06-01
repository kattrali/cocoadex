
module Cocoadex

  # Helper for finding and indexing DocSets
  class DocSetHelper

    IOS_DOCSET_PREFIX="com.apple.adc.documentation.AppleiOS"
    OSX_DOCSET_PREFIX="com.apple.adc.documentation.AppleOSX"
    XCODE_DOCSET_PREFIX="com.apple.ADC_Reference_Library.DeveloperTools"
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
        paths = ROOT_PATHS.map do |path|
          Dir.glob(File.expand_path(path)+'/*/')
        end.flatten.sort

        rejected_prefixes = [OSX_DOCSET_PREFIX, IOS_DOCSET_PREFIX, XCODE_DOCSET_PREFIX]
        rejected_paths = rejected_prefixes.map {|p| reject_paths(paths, p)}.flatten
        paths.reject! {|p| rejected_paths.include?(p) }

        paths
      end
    end

    def self.search_and_index paths=docset_paths
      docsets = []

      paths.map do |path|
        if docset = Parser.parse(path)
          docsets << docset
        end
      end

      write(docsets) if docsets.size > 0
      logger.info "Done! #{docsets.size} DocSet#{docsets.size == 1 ? '':'s'} indexed."
    end

    def self.show_schema docset_path, output_path
      if docset = Parser.parse(docset_path, DiffTokenizer)
        DiffSerializer.write_array(output_path, DiffTokenizer.tokens, :overwrite)
        puts File.read(output_path)
      end
    end

    def indexed_docsets
      @docsets ||= Serializer.read(data_path)
    end

    def self.read
      @docsets = Serializer.read(data_path)
    end

    def self.write docsets
      @docsets = docsets
      Tokenizer.persist
      CompletionHelper.generate_tags!
      Serializer.write_array(data_path, docsets, :overwrite)
    end

    private

    def self.reject_paths paths, prefix
      filtered_paths = paths.select {|p| File.basename(p).start_with?(prefix) }
      name_to_keep = File.basename(filtered_paths.shift)
      filtered_paths.select {|p| File.basename(p) != name_to_keep }
    end
  end
end