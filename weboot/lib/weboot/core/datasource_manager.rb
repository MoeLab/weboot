require_relative 'datasource_accessor'

module Weboot
  class DataSourceManager

    def initialize
      @datasources = Hash.new
      @primary_datasource_accessor = nil
    end

    def add(name, instance)
      raise KeyError, 'duplicated datasource name: %s' % [name] if @datasources.key?(name)
      Weboot.logger.debug :datasource, 'register datasource: %s' % [name]
      @datasources[name] = {
        :datasource => instance,
        :accessor => DataSourceAccessor.new(instance)
      }
      self
    end

    def accessor(name)
      datasource = @datasources[name]
      raise IndexError, 'datasource not found: %s' % [name] if datasource.nil?
      datasource[:accessor]
    end

    def primary_datasource=(name)
      raise KeyError, 'key not exist: %s' % [name] unless @datasources.key?(name)
      Weboot.logger.debug :datasource, 'primary datasource = %s' % [name]
      @primary_datasource_name = name
      @primary_datasource_accessor = @datasources[@primary_datasource_name][:accessor]
    end

    def primary_datasource_accessor
      @primary_datasource_accessor
    end

  end
end
