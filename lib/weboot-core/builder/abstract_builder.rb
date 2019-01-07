module Weboot
  class AbstractBuilder
    attr_reader :name, :provider_string, :provider
    attr_accessor :configs

    INTERFACE_TYPE = nil

    def initialize(name)
      @name = name
      @configs = []
    end

    def settings=(settings)
      @configs.clear
      if settings.is_a?(String)
        @provider_string = settings
      else
        @provider_string = settings[::Weboot::Constant::PROVIDER]
        push_config(settings[::Weboot::Constant::CONFIG])
      end
      @provider = ::Weboot.get_provider(@provider_string)
      raise ArgumentError, 'provider must include %s for validation.' % (INTERFACE_TYPE.name) unless @provider.include?(INTERFACE_TYPE)
    end

    def push_config(config)
      @configs.push(config) unless config.nil?
    end

    def pop_config
      @configs.pop
    end

    def merged_config
      @configs.inject({}) do | merged, config |
        ::Weboot.merge(merged, config)
      end
    end

    def clone
      o = super.clone
      o.configs = @configs.clone
      o
    end

    def instance
      @provider.new(@name, merged_config)
    end

  end
end
