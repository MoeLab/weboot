module Weboot
  class Pipeline

    def initialize(name, suffix, filters)
      @key = key
      @filters = Array.new
    end

    def add_filter(filter)
      @filters.push(filter)
    end

    def run(file)

    end

  end
end
