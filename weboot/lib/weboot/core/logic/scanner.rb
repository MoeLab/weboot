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
        @site.source_dir = ::Weboot.assert_dir File.expand_path (source_dir.nil?) ? @site.root_dir : File.join(@site.root_dir, source_dir)
        Weboot.logger.info :scan, 'source-dir = %s' % [@site.source_dir]

        root_coll = Collection.new nil, '', ConfigReader.read(File.join Weboot::SRC_DIR, 'default_collection_config.yaml')
        scan_dir root_coll, '/'

        @hook_manager.trigger_phase_hooks 'after-scanning'
      end

      private def scan_dir(parent_coll, dir_relpath)
        dirpath = File.join @site.source_dir, dir_relpath
        coll = Collection.new parent_coll, dir_relpath, load_collection_config(dirpath)
        Weboot.logger.trace :scan, '%s %s' % [(coll.enabled?) ? 'scan' : 'skip', dir_relpath]
        return unless coll.enabled?

        Dir.children(dirpath).sort! do |a, b|
          # directory after (greater than) file
          ((File.directory? File.join dirpath, a) ? 1 : 0) - ((File.directory? File.join dirpath, b) ? 1 : 0)
        end.each do |filename|
          filepath = File.join dirpath, filename
          file_relpath = File.join dir_relpath, filename
          if File.directory? filepath
            if coll.include? filename + '/'
              scan_dir coll, file_relpath + '/'
            else
              Weboot.logger.trace :scan, 'exclude %s/' % [file_relpath]
            end
          elsif coll.include? filename
            config_stack = ConfigStack.new
            config_stack.push coll.merge_page_config
            config_stack.push load_file_metadata filepath
            page = Page.new file_relpath, filepath, config_stack.merge
            Weboot.logger.trace :scan, '%s %s' % [(page.enabled?) ? 'shot' : 'skip', file_relpath]
            next unless page.enabled?
            @pages.append page
          else
            Weboot.logger.trace :scan, 'exclude %s' % [file_relpath]
          end
        end
      end

      private def load_collection_config(dirpath)
        filepath = File.join dirpath, '_config.yaml'
        (File.exist? filepath) ? ConfigReader.read(filepath) : nil
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
            break if line.start_with? '---'
            raw << line
          end
          config = ConfigReader.parse raw.string, format
          config.store 'lineno', f.lineno
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
