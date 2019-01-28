module Weboot
  module Logic
    class << self

      def write
        target_dir = @site.target_dir
        target_dir = File.expand_path (target_dir.nil?) ? @site.root_dir : File.join(@site.root_dir, target_dir)
        Dir.mkdir target_dir unless Dir.exist? target_dir
        @site.target_dir = target_dir
        Weboot.logger.info :write, 'target-dir = %s' % [@site.target_dir]

        @pages.each do |page|
          Weboot.logger.trace :write, '%s %s' % [(page.enabled?) ? 'save' : 'skip', page.relpath]
          next unless page.enabled?
          output_filename = get_output_filename page
          next if output_filename.nil?
          File.write output_filename, page.content
        end

        @hook_manager.trigger_phase_hooks 'after-writing'
      end

      private def get_output_filename(page)
        nil
      end

    end
  end
end
