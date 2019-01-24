require_relative 'abstract_builder'

module Weboot
  class DataSourceBuilder < AbstractBuilder

    def interface_type
      DataSource::DataSourceInterface
    end

  end
end
