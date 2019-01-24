require_relative 'filter_manager'

module Weboot
  class Pipeline

    attr_reader :name

    def initialize(name, suffixes, filters)
      @name = name
      @suffixes = suffixes
      @filters = filters
    end

    def match(filename)
      @suffixes.each do |suffix|
        return true if filename.end_with?(suffix)
      end
      false
    end

    def run(page)
      @filters.inject(page) do |filter|
        filter.run(page)
      end
    end

  end
end
