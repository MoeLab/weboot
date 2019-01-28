require_relative '../core/filter'

module Weboot
  module Filter
    class NopFilter
      include FilterInterface

      def after_initialize
        @hooks = (@config['hooks'] || []).map do |settings|
          Weboot::Logic.hook_manager.get_builder settings
        end
      end

      def run(page)
        @hooks.each do |builder|
          hook = builder.instance
          hook.run
        end
      end
    end
  end
end
