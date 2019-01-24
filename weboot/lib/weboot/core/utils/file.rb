module Weboot
  class << self

    def assert_dir(dirpath)
      raise IOError, 'dir not found: %s' % [dirpath] unless Dir.exist?(dirpath)
      dirpath
    end

    def assert_file(filepath)
      raise IOError, 'file not found: %s' % [filepath] unless File.exist?(filepath)
      filepath
    end

  end
end