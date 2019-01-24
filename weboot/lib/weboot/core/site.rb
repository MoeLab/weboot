require_relative 'config'
require_relative 'utils/file'
require_relative 'utils/variable'

module Weboot
  class Site < Config

    def initialize(config)
      super config, false
    end

    def root_dir=(dirpath)
      self.store 'root-dir', ::Weboot.assert_dir(dirpath)
    end

    def root_dir
      self.fetch 'root-dir'
    end

    def source_dir=(dirpath)
      self.store 'source-dir', ::Weboot.assert_dir(dirpath)
    end

    def source_dir
      self.fetch 'source-dir'
    end

    def target_dir=(dirpath)
      self.store 'target-dir', ::Weboot.assert_dir(dirpath)
    end

    def target_dir
      self.fetch 'target-dir'
    end

  end
end
