module Weboot
  module Hook
    module HookInterface

      attr_reader :name

      def initialize(name, config)
        @name = name
        @config = config
      end

      def inspect
        '%s$%s' % [self.class.name, @name]
      end

      def run
        raise NotImplementedError, self.inspect
      end

    end
  end
end
