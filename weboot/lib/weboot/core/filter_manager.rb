module Weboot
  class FilterManager

    def initialize
      @filters = {}
    end

    def register(name, builder)
      raise KeyError, 'duplicated filter name: %s' % [name] if @filters.key?(name)
      @filters[name] = builder
    end

    def get_builder(name)
      @filters.fetch(name)
    end

  end
end
