module Weboot
  class ConfigStack

    def initialize
      @stack = []
      @merged = nil
    end

    def push(config)
      unless config.nil?
        @merged = nil
        @stack.push(config)
      end
      self
    end

    def pop
      @merged = nil
      (@stack.empty) ? nil : @stack.pop
    end

    def clear
      @merged = nil
      @stack.clear
      self
    end

    def clone
      o = super.clone
      @stack = @stack.clone
      o
    end

    def merge
      return @merged unless @merged.nil?
      @merged = @stack.inject({}) do | merged, config |
        ::Weboot.merge(merged, config)
      end
    end

  end
end