module Weboot
  class Pipeline

    attr_reader :name

    def initialize(name, suffixes, filters)
      @name = name
      @suffixes = suffixes
      @filters = filters
      @cached = false
    end

    def match?(filename)
      @suffixes.each do |suffix|
        return true if filename.end_with? suffix
      end
      false
    end

    def run(page)
      unless @cached
        @filters.map! &:instance
        @cached = true
      end
      @filters.each do |filter|
        break unless filter.run page
      end
    end

  end
end
