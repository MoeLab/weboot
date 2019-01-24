require_relative '../core/datasource'

module Weboot
  module DataSource
    class FileDataSource
      include DataSourceInterface

      def initialize(name, config)
        @data_dir = config['dir']
        readers = config['readers']
        unless readers.nil?
          readers.each do |setting|

          end
        end
      end

      def key?(key)
        true
      end

      def get(key)
      end

      def set(key, value)
        raise NotImplementedError
      end

    end
  end
end
