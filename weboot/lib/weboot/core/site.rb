require_relative 'config'
require_relative 'utils/file'
require_relative 'utils/variable'

module Weboot
  class Site < Config

    def root_dir=(dirpath)
      self.store('root-dir', ::Weboot.assert_dir(dirpath))
    end

    def root_dir
      self.fetch('root-dir')
    end

    def plugin_dir=(dirpath)
      self.store('plugin-dir', ::Weboot.assert_dir(dirpath))
    end

    def plugin_dir
      self.fetch('plugin-dir')
    end

    def source_dir=(dirpath)
      self.store('source-dir', ::Weboot.assert_dir(dirpath))
    end

    def source_dir
      self.fetch('source-dir')
    end

  end
end
