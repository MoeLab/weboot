module Weboot
  class FilterManager

    def initialize
      @filters = {}
    end

    def register(name, builder)
      raise KeyError, 'duplicated filter name: %s' % [name] if @filters.key?(name)
      Weboot.logger.debug :filter, 'register filter: %s' % [name]
      @filters[name] = builder
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
      original_builder = @filters.fetch name
      raise ArgumentError, 'filter not found: %s' % [name] if original_builder.nil?
      builder = original_builder.copy
      builder.push_config config
      builder
    end

  end
end
