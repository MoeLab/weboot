require_relative 'config_stack'
require_relative 'utils/reflect'

module Weboot
  class AbstractBuilder
    attr_reader :name, :provider_string, :provider
    attr_accessor :configs

    def initialize(name)
      @name = name
      @config_stack = ConfigStack.new
    end

    def interface_type
      NilClass
    end

    def settings=(settings)
      @config_stack.clear
      if settings.is_a?(String)
        @provider_string = settings
      else
        @provider_string = settings['provider']
        push_config(settings['config'])
      end
      @provider = ::Weboot.get_provider(@provider_string)
      raise ArgumentError, '%s not found: \'%s\'' % [interface_type.name, @provider_string] if @provider.nil?
      raise ArgumentError, '%s not included: \'%s\'' % [interface_type.name, @provider_string] unless @provider.include?(interface_type)
      self
    end

    def push_config(config)
      @config_stack.push(config)
      self
    end

    def pop_config
      @config_stack.pop
    end

    def merged_config
      @config_stack.merge
    end

    def copy
      o = self.clone
      @config_stack = @config_stack.copy
      o
    end

    def instance
      @provider.new(@name, merged_config)
    end

  end
end
