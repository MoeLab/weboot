require_relative '../core/datasource'

module Weboot
  module DataSource
    class RandomDataSource
      include DataSourceInterface

      def initialize(name, config)
        seed = config['seed'] || Random.new_seed
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
