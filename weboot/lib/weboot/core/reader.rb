module Weboot
  module Reader
    module ReaderInterface

      def initialize(config)
        @config = config
      end

      def parse(input)
        raise NotImplementedError
      end

    end

  end
end
