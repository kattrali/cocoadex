
module Cocoadex

  # DocSet index and html documentation file parser
  class Parser
    GenericReference  = ->(title) { title.include?("Reference") }
    DeprecatedMethods = ->(title) { title =~ /^Deprecated ([A-Za-z]+) Methods$/ }
    ClassReference    = ->(title) {
      title.include?("Class Reference") or title.include?("Protocol Reference") }
    CategoryReference = ->(title) { title.include?("Category Reference") }

    IGNORED_DIRS = [
      'codinghowtos', 'qa',
      'featuredarticles','navigation',
      'recipes','releasenotes',
      'samplecode','Conceptual',
      'technotes','History',
      'Introduction','GettingStarted'
    ]

    IGNORED_FILES = [
      'RevisionHistory','Introduction'
    ]

    def self.ignored? path
      (path.split('/') & IGNORED_DIRS).size > 0 or
      IGNORED_FILES.include?(File.basename(path).sub('.html','')) or
      (File.basename(path) == 'index.html' && File.exist?(File.join(File.dirname(path),'Reference')))
    end

    def self.parse docset_path, tokenizer=Tokenizer
      plist = File.join(docset_path,"Contents", "Info.plist")
      if File.exist? plist
        docset = DocSet.new(plist)
        files  = Dir.glob(docset_path+"/**/*.html").select {|f| not ignored?(f) }

        if files.size > 0
          logger.info "Parsing documentation tokens in #{docset.name}. This may take a moment..."
          pbar  = ProgressBar.create(:title => "#{docset.platform} #{docset.version}",:total => files.size)
          files.each_with_index do |f,i|
            index_html(docset, f, i, tokenizer)
            pbar.increment
          end
          pbar.finish
          logger.info "  Tokens Indexed."
        else
          logger.info "  No files to parse."
        end

        docset
      end
    end

    def self.index_html docset, path, index, tokenizer
      logger.debug "  Parsing path: #{path}"

      doc = Nokogiri::HTML(IO.read(path))
      if title = doc.css("#IndexTitle").first['content'] || doc.css("#contents a").first['title']
        case title
        when ClassReference
          logger.debug "  Parsing CLASS"
          tokenizer.tokenize_class(docset.name, path, index)
        when CategoryReference
          logger.debug "  Parsing CATEGORY"
          tokenizer.tokenize_category(docset.name, path, index)
        when GenericReference
          logger.debug "  Parsing GENERIC"
          tokenizer.tokenize_ref(docset.name, path, index)
        when DeprecatedMethods
          # TODO
        else
          # TODO
        end
      end
    end
  end
end