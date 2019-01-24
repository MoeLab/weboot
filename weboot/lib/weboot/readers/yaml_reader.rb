require 'psych'
require_relative '../core/reader'

module Weboot
  module Reader
    class YamlReader
      include ReaderInterface

      def parse(input)
        doc = Psych.parse(input)
        doc.to_ruby
      end
    end
  end
end
