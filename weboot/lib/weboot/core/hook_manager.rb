module Weboot
  class HookManager

    def initialize
      @hooks = {}
      @phase_hooks_map = {}
    end

    def register(name, builder)
      raise KeyError, 'duplicated hook name: %s' % [name] if @hooks.key?(name)
      @hooks[name] = builder
      self
    end

    def get_builder(name)
      @hooks.fetch(name)
    end

    def add_phase_hook(phase, builder)
      if @phase_hooks_map.key?(phase)
        phase_hooks = @phase_hooks_map[phase]
      else
        phase_hooks = []
        @phase_hooks_map[phase] = phase_hooks
      end
      phase_hooks.append(builder)
      self
    end

    def trigger_phase_hooks(phase)
      phase_hooks = @phase_hooks_map[phase]
      return if phase_hooks.nil?
      phase_hooks.each do |builder|
        hook = builder.instance
        hook.run
      end
      self
    end

  end
end
