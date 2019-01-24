require_relative 'config_stack'

module Weboot
  class Page

    attr_reader :relpath, :fullpath, :basename
    attr_reader :config
    attr_accessor :content

    def initialize(relpath, fullpath, config)
      @relpath = relpath
      @fullpath = fullpath
      @basename = File.basename(relpath)

      @config = config

      @content = nil
    end

    def enabled?
      enabled = @config['enabled']
      enabled || enabled.nil?
    end

  end
end
