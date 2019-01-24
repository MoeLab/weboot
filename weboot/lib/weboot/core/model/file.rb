# frozen_string_literal: true

module Weboot
  class File
    attr_reader :scope
    attr_reader :path

    def initialize(dir_scope, path)
      @scope = Scope.new(dir_scope)
      @path = path
    end
    
    def open_file
      @f = File.open(@path, 'r') if @f.nil?
      @f
    end

    def load_metadata
      @f.rewind
      begin
        firstline = @f.readline
        return nil unless firstline.start_with?(METADATA_BOUND)
        data_format = firstline[3..-1].rstrip!
        raw = StringIO.new
        until @f.eof? do
          line = @f.readline
          break if line.start_with?(METADATA_BOUND)
          raw << line
        end
        data = raw.string
        @scope.merge!(parse_metadata(data_format, data))
      rescue EOFError
      end
    end

    # @param format unused
    def parse_metadata(format, data)
      yaml = YAML.safe_load(data)
      @scope.merge!(yaml)
    end

    S_HANDLER = 'pipeline'.freeze

    def pipeline
      @scope[S_HANDLER]
    end

    def fullpath
      ::Weboot.parse_string('${prefix}/${slug}', @scope)
    end

  end
end
