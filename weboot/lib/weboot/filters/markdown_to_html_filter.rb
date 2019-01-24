require_relative '../core/filter'

module Weboot
  module Filter
    class MarkdownToHtmlFilter
      include FilterInterface

      def run(page)
        p 'md'
      end
    end
  end
end
