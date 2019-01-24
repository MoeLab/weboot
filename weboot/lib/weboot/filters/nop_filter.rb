require_relative '../core/filter'

module Weboot
  module Filter
    class NopFilter
      include FilterInterface

      def run(page)
        p 'nop'
      end
    end
  end
end
