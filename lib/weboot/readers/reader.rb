module Weboot
  module Reader
    module ReaderInterface

      def initialize
        raise NotImplementedError
      end

      def run(input)
        raise NotImplementedError
      end

    end

  end
end
