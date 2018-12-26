# frozen_string_literal: true

module Weboot
  class Scope

    def initialize(parent)
      @parent = parent
      @vars = Hash.new
    end

    # replaced if duplicate
    def merge(vars)
      @vars.merge!(vars)
    end

    def key?(key)
      @vars.key?(key)
    end

    def []=(key, value)
      @vars[key] = value
    end

    def [](key)
      return @vars[key] if @vars.key?(key)
      return nil if @parent.nil?
      @parent[key]
    end

    def parse_string(format)
      ::Weboot.parse_string(format, self)
    end

  end
end
