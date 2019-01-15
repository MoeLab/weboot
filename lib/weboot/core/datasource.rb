module Weboot
  module DataSource
    module DataSourceInterface

      def initialize(name, config)
        raise NotImplementedError
      end

      def key?(key)
        raise NotImplementedError
      end

      def get(key)
        raise NotImplementedError
      end

      def set(key, value)
        raise NotImplementedError
      end

    end
  end
end
