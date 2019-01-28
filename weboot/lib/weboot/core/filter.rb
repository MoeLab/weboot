module Weboot
  module Filter
    module FilterInterface

      attr_reader :name

      def initialize(name, config)
        @name = name
        @config = config
        after_initialize
      end

      def after_initialize
      end

      def run(page)
        raise NotImplementedError, self.inspect
      end

      def inspect
        '%s$%s' % [self.class.name, @name]
      end

    end
  end
end
