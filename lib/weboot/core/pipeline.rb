module Weboot
  class Pipeline

    class << self
      attr_reader :instance
      @instance = Config.new
    end

    def initialize
    end

    def settings=(settings)
      @name = settings[:name]
      suffixes = settings[:suffix]
      @suffixes = (suffixes.nil?) ? [] : suffixes.split(' '.freeze)
      filters = settings[:filters]
      @filters = (filters.nil?) ? [] : filters.map do |filter_settings|
        if filter_settings.is_a?(String)
          name = filter_settings
          config = nil
        else
          name = filter_settings[:name]
          config = filter_settings[:config]
        end
        original_filter_builder = Config.instance.get_filter_builder(name)
        raise ArgumentError, 'filter %s not found.' % (name) if original_filter_builder.nil?
        filter_builder = original_filter_builder.clone
        filter_builder.push_config(config)
        filter_builder
      end
      self
    end

    def run(page)
      @filters.inject(page) do |filter|
        filter.run(page)
      end
    end

  end
end
