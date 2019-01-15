module Weboot
  module Config

    class << self
      attr_reader :instance
      @instance = Config.new
    end

    def initialize
      @hooks = {}
      @filters = {}
      @phase_hooks_map = {}
    end

    def register_hook(name, builder)
      raise KeyError, 'duplicated hook name: %s' % (name) if @hooks.key?(name)
      @hooks[name] = builder
    end

    def register_filter(name, builder)
      raise KeyError, 'duplicated filter name: %s' % (name) if @filters.key?(name)
      @filters[name] = builder
    end

    def add_phase_hook(phase, builder)
      if @phase_hooks_map.key?(phase)
        phase_hooks = @phase_hooks_map[phase]
      else
        phase_hooks = []
        @phase_hooks_map[phase] = phase_hooks
      end
      phase_hooks.append(builder)
    end

    def get_hook_builder(name)
      @hooks.fetch(name)
    end

    def get_filter_builder(name)
      @filters.fetch(name)
    end

    def trigger_phase_hooks(phase)
      phase_hooks = @phase_hooks_map[phase]
      return if phase_hooks.nil?
      phase_hooks.each do |builder|
        hook = builder.instance
        hook.run
      end
    end

    class SiteConfig

      def initialize(config)
        @config = config
      end

      def fetch(name)
        @config.fetch(name)
      end

      def store(name, value)
        @config.store(name, value)
      end

    end

  end
end
