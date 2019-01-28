require_relative '../core/hook'

module Weboot
  module Hook
    class NopHook
      include HookInterface

      def run
        # no operation
        p 'nop %s' %[@config]
      end

    end
  end
end
