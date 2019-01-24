require_relative '../core/hook'

module Weboot
  module Hook
    class NopHook
      include HookInterface

      def run
        # no operation
      end

    end
  end
end
