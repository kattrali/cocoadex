
module Cocoadex

  # Move data to and from disk
  class Serializer
    SEPARATOR = "--__--"

    # Read a serialized cache file into an Array
    def self.read path
      $/=SEPARATOR
      array = []
      File.open(path, "r").each do |object|
        array << Marshal::load(object)
      end
      array
    end

    # Ensure parent paths exist
    def self.check_path path
      unless File.exists? File.dirname(path)
        FileUtils.mkdir_p File.dirname(path)
      end
    end

    # Write text to a file
    def self.write_text path, text, style=:overwrite
      check_path path

      mode = style_to_mode(style)

      File.open(path, 'w') do |file|
        file.print text
      end
    end

    # Write a cache Array as a serialized file
    def self.write_array path, array, style
      check_path path

      mode = style_to_mode(style)

      File.open(path, mode) do |file|
        array.each do |object|
          file.print(Marshal.dump(object))
          file.print SEPARATOR
        end
      end
    end

    def self.style_to_mode style
      case style
        when :append then 'a'
        when :overwrite then 'w'
        else
          raise "Unknown file mode: #{style}"
      end
    end
  end
end