module Weboot
  class HookManager

    def initialize
      @hooks = {}
      @phase_hooks_map = {}
    end

    def register(name, builder)
      raise KeyError, 'duplicated hook name: %s' % [name] if @hooks.key? name
      Weboot.logger.debug :hook, 'register hook: %s' % [name]
      @hooks[name] = builder
      self
    end

    def get_builder(settings)
      if settings.is_a? String
        name = settings
        config = nil
      else
        name = settings['name']
        config = settings['config']
      end
      original_builder = @hooks.fetch name
      raise ArgumentError, 'hook not found: %s' % [name] if original_builder.nil?
      builder = original_builder.copy
      builder.push_config config
      builder
    end

    def add_phase_hook(phase, builder)
      Weboot.logger.debug :hook, 'phase %s add hook: %s' % [phase, builder.name]
      if @phase_hooks_map.key? phase
        phase_hooks = @phase_hooks_map[phase]
      else
        phase_hooks = []
        @phase_hooks_map[phase] = phase_hooks
      end
      phase_hooks.append builder
      self
    end

    def trigger_phase_hooks(phase)
      Weboot.logger.debug :hook, 'phase %s begin' % [phase]
      phase_hooks = @phase_hooks_map[phase]
      unless phase_hooks.nil?
        phase_hooks.each do |builder|
          hook = builder.instance
          hook.run
        end
      end
      Weboot.logger.debug :hook, 'phase %s end' % [phase]
    end

  end
end
