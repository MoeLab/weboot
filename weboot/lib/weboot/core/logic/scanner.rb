require_relative '../collection'
require_relative '../config_reader'
require_relative '../config_stack'
require_relative '../page'
require_relative '../utils/file'

module Weboot
  module Logic
    class << self

      def scan()
        @pages = []

        source_dir = @site['source-dir']
        source_dir = File.join(@site.root_dir, source_dir) unless source_dir.nil?
        @site.source_dir = ::Weboot.assert_dir File.expand_path(source_dir)
        Weboot.logger.info :scan, 'source-dir: %s' % [@site.source_dir]

        root_coll = Collection.new nil, '', ConfigReader.read(File.join Weboot::SRC_DIR, 'default_collection_config.yaml')
        scan_dir root_coll, '/'
      end

      private def scan_dir(parent_coll, dir_relpath)
        dirpath = File.join @site.source_dir, dir_relpath

        coll = Collection.new parent_coll, dir_relpath, load_collection_config(dirpath)
        return unless coll.enabled?

        Dir.each_child(dirpath) do |filename|
          filepath = File.join dirpath, filename
          file_relpath = File.join dir_relpath, filename
          if File.directory? filepath
            next unless coll.include? filename + '/'
            scan_dir coll, file_relpath + '/'
          elsif coll.include? filename
            load_file filepath, coll.merge_page_config
          end
        end
      end

      private def load_collection_config(dirpath)
        filepath = File.join dirpath, '_config.yaml'
        (File.exist? filepath) ? ConfigReader.read(filepath) : nil
      end

      private def load_file(filepath, coll_page_config)
        config_stack = ConfigStack.new
        config_stack.push coll_page_config
        config_stack.push load_file_metadata filepath
        page = Page.new filepath, config_stack.merge
        return unless page.enabled?
        @pages.append page
      end

      private def load_file_metadata(filepath)
        f = File.open filepath, 'r'
        begin
          3.times do
            return nil if f.readchar != '-'
          end
          format = f.readline.rstrip!
          format = 'yaml' if format.empty?

          raw = StringIO.new
          until f.eof? do
            line = f.readline
            break if line.start_with?('---')
            raw << line
          end
          config = ConfigReader.parse(raw.string, format)
          config.store('lineno', f.lineno)
          config
        rescue EOFError
          nil
        ensure
          f.close
        end
      end

    end
  end
end
