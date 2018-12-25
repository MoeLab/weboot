module Weboot
  class Scope

    def initialize(parent)
      @parent = parent
      @vars = Hash.new
    end

    def [](key)
      return @vars[key] if @vars.key?(key)
      return nil if @parent.nil?
      @parent[key]
    end

  end
end
