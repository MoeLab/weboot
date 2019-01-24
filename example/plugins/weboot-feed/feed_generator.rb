module Weboot
  module Plugin
    module Generator
      class FeedGenerator
        include ::Weboot::Hook::HookInterface

        def run
          p 'feed'
        end
      end
    end
  end
end
