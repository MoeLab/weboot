require_relative '../core/filter'

module Weboot
  module Filter
    class LayeredFilter
      include FilterInterface

      def run(page)
        p 'layered'
      end
    end
  end
end
