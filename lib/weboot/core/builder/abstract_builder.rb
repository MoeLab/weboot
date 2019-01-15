module Weboot
  class AbstractBuilder
    attr_reader :name, :provider_string, :provider
    attr_accessor :configs

    InterfaceType = nil

    def initialize(name)
      @name = name
      @config_stack = ConfigStack.new
    end

    def settings=(settings)
      @config_stack.clear
      if settings.is_a?(String)
        @provider_string = settings
      else
        @provider_string = settings[:provider]
        push_config(settings[:config])
      end
      @provider = ::Weboot.get_provider(@provider_string)
      raise ArgumentError, 'provider must include %s for validation.' % (InterfaceType.name) unless @provider.include?(InterfaceType)
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

    def clone
      o = super.clone
      @config_stack = @config_stack.clone
      o
    end

    def instance
      @provider.new(@name, merged_config)
    end

  end
end
