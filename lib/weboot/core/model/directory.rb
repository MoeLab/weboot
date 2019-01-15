# frozen_string_literal: true

module Weboot
  class Directory

    METADATA_FILENAME = '_config.yaml'.freeze

    def initialize(parent_scope, path, filenames)
      @scope = Scope.new(parent_scope)
      @path = path
      @files = filenames
      load_metadata(File.join(path, METADATA_FILENAME)) if @files.include?(METADATA_FILENAME)
    end

    def load_metadata(fullname)
      vars = YAML.load_file(fullname)
      @scope.merge!(vars)
    end

  end
end
