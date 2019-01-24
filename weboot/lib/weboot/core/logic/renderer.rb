module Weboot
  module Logic
    class << self

      def render
        @pages.each do |page|
          pipeline = get_pipeline page
          pipeline.run page unless pipeline.nil?
        end

        @hook_manager.trigger_phase_hooks 'after-rendering'
      end

      private def get_pipeline(page)
        pipeline_name = page.config['pipeline']
        if pipeline_name.nil?
          @pipeline_manager.match page.basename
        else
          pipeline = @pipeline_manager.get pipeline_name
          raise ArgumentError, 'pipeline not found: %s' % [pipeline_name] if pipeline.nil?
          pipeline
        end
      end

    end
  end
end
