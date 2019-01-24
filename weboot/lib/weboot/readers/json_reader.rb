require 'json'
require_relative '../core/reader'

module Weboot
  module Reader
    class JsonReader
      include ReaderInterface

      private def parse_one_config(name)
        v = @config[name.to_s]
        @options[name.to_sym] = v unless v.nil?
      end

      private def parse_config
        @options = {}
        @config.each_key(&method(:parse_one_config))
      end

      def parse(input)
        parse_config if @options.nil?
        JSON.parse(input, opts=@options)
      end
    end
  end
end
