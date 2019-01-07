module Weboot
  class DataHub

    class << self
      attr_reader :instance
      @instance = DataHub.new
    end

    def initialize
      @datasources = Hash.new
    end

    def add(name, instance)
      raise KeyError, 'duplicated datasource name: %s' % (name) if @datasources.key?(name)
      @datasources[name] = instance
    end

    def fetch(name)
      datasource = @datasources[name]
      raise IndexError, 'unknown datasource: %s' % (name) if datasource.nil?
      datasource
    end

    def primary_datasource=(name)
      raise KeyError, 'key not existed: %s' % (name) unless @datasources.key?(name)
      @primary_datasource_name = name
      @primary_datasource = @datasources[@primary_datasource_name]
    end

    def primary_datasource
      @primary_datasource
    end

  end
end
