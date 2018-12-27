# frozen_string_literal: true

module Weboot
  class Pipeline

    def initialize(key)
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
