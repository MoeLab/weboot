module Weboot
  module Filter
    module FilterInterface

      def run(page)
        raise NotImplementedError
      end

    end
  end
end
