require_relative 'utils/variable'

module Weboot
  class ConfigStack

    def initialize
      @stack = []
      @cache = []
    end

    def push(config)
      @stack.push config
      @cache.push nil
      self
    end

    def pop
      value = (@stack.empty?) ? nil : @stack.pop
      @cache.pop
      value
    end

    def clear
      @stack.clear
      @cache.clear
      self
    end

    def copy
      o = self.clone
      @stack = @stack.clone
      @cache = @cache.clone
      o
    end

    def merge
      return {} if @stack.empty?
      merge_iter(@stack.length - 1)
    end

    private def merge_iter(i)
      return @cache[i] unless @cache[i].nil?
      merged = (i == 0) ? {} : merge_iter(i - 1)
      @cache[i] = (@stack[i].nil?) ? merged : Weboot.vars_merge(merged, @stack[i])
    end

  end
end
