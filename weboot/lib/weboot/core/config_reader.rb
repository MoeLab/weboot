require_relative '../readers/weboot_manifest'

module Weboot
  class ConfigReader
    class << self

      private def get_reader_by_format(format)
        case format
        when 'csv'
          @csv ||= Reader::CsvReader.new(nil)
        when 'json'
          @json ||= Reader::JsonReader.new(nil)
        when 'yml', 'yaml'
          @yaml ||= Reader::YamlReader.new(nil)
        else
          raise KeyError, 'reader not found: \'%s\'' % [format]
        end
      end

      private def get_reader_by_filename(name)
        begin
          get_reader_by_format(name.rpartition('.')[2])
        rescue KeyError
          raise KeyError, 'reader not found: \'%s\'' % [name]
        end
      end

      def read(fullname)
        raw = File.read(fullname)
        reader = get_reader_by_filename(fullname)
        reader.parse(raw)
      end

      def parse(raw, format)
        reader = get_reader_by_format(format)
        reader.parse(raw)
      end

    end
  end
end
