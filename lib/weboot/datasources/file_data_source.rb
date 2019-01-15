module Weboot
  module DataSource
    class FileDataSource

      include DataSourceInterface

      def initialize(name, config)
        seed = config['seed'.freeze]
        @random = Random.new(seed)
      end

      def key?(key)
        true
      end

      def get(key)
        @random.bytes(1)
      end

      def set(key, value)
        raise NotImplementedError
      end

    end
  end
end
