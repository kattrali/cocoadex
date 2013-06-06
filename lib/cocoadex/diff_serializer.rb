
module Cocoadex

  # Output parsed tokens into a flat diffable format
  class DiffSerializer < Serializer

    def self.read path
      array = []
      File.open(path, "r").each_line do |line|
        type, term = line.split(' ')
        array << Keyword.new(term, type, nil, nil)
      end
      array
    end

    # Write a cache Array as a serialized file
    def self.write_array path, array, style
      check_path path

      mode = style_to_mode(style)

      File.open(path, mode) do |file|
        array.each do |keyword|
          file.puts("#{keyword.type} #{keyword.term}")
        end
      end
    end
  end
end