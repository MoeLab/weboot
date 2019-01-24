require_relative 'config_stack'

module Weboot
  class Page

    def initialize(fullname, config)
      @filename = fullname
      @config = config
    end

    def enabled?
      enabled = @config['enabled']
      enabled || enabled.nil?
    end

  end
end
