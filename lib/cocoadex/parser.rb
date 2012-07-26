
module Cocoadex
  class Parser

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

    def self.class_ref? title
      title.include? "Class Reference" or title.include? "Protocol Reference"
    end

    def self.deprecated? title
      title =~ /^Deprecated ([A-Za-z]+) Methods$/
    end

    def self.parse docset_path
      plist = File.join(docset_path,"Contents", "Info.plist")
      if File.exist? plist
        docset = DocSet.new(plist)
        logger.info "Parsing docset tokens in #{docset.name}. This may take a moment..."

        files = Dir.glob(docset_path+"/**/*.html")
        files.reject! {|f| ignored?(f) }
        files.each_with_index do |f,i|
          index_html(docset,f,i)
        end

        logger.info "  Tokens Indexed: #{Keyword.datastore.size}"
        docset
      end
    end

    def self.index_html docset, path, index
      logger.debug "  Parsing path: #{path}"

      doc = Nokogiri::HTML(IO.read(path))
      title_nodes = doc.css("#IndexTitle")
      unless title_nodes.size == 0
        title = title_nodes.first['content']

        if class_ref? title
          logger.debug "Caching #{title}"
          Keyword.tokenize_class docset.name, path, index
        elsif title.include? "Reference"
          Keyword.tokenize_ref docset.name, path, index
        end
      end
    end
  end
end