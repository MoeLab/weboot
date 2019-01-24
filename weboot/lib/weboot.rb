# rubygems
require 'rubygems'

require_relative 'weboot/core/constant'
require_relative 'weboot/core/logger'

require_relative 'weboot/hooks/weboot_manifest'
require_relative 'weboot/readers/weboot_manifest'
require_relative 'weboot/datasources/weboot_manifest'
require_relative 'weboot/filters/weboot_manifest'

require_relative 'weboot/core/logic/global'
require_relative 'weboot/core/logic/configurator'
require_relative 'weboot/core/logic/scanner'
require_relative 'weboot/core/logic/renderer'
require_relative 'weboot/core/logic/writer'

module Weboot
  class << self

    def logger=(writer)
      @logger = Logger.new(writer, :info)
    end

    def logger
      @logger
    end

    def run(root_dir)
      self.logger = $stderr

      Logic.configure root_dir
      Logic.scan
      Logic.render
      Logic.write
    end

  end
end
