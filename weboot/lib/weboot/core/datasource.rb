module Weboot
  module DataSource
    module DataSourceInterface

      attr_reader :name

      def initialize(name, config)
        @name = name
        @config = config
      end

      def inspect
        '%s$%s' % [self.class.name, @name]
      end

      def key?(key)
        raise NotImplementedError, self.inspect
      end

      def get(key)
        raise NotImplementedError, self.inspect
      end

      def set(key, value)
        raise NotImplementedError, self.inspect
      end

    end
  end
end
