require_relative 'abstract_builder'

module Weboot
  class HookBuilder < AbstractBuilder

    def interface_type
      Hook::HookInterface
    end

  end
end
