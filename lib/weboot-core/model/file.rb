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
      open_file
      @f.rewind
      firstline = @f.readline

    end

    def fullpath
      ::Weboot.parse_string('${prefix}/${slug}', @scope)
    end

  end
end
