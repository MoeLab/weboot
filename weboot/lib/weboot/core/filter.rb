module Weboot
  module Filter
    module FilterInterface

      attr_reader :name

      def initialize(name, config)
        @name = name
        @config = config
      end

      def inspect
        '%s$%s' % [self.class.name, @name]
      end

      def run(page)
        raise NotImplementedError, self.inspect
      end

    end
  end
end
