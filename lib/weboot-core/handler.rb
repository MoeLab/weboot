# frozen_string_literal: true

module Weboot
  class Handler

    def initialize(key)
      @key = key
      @filters = Array.new
    end

    def add_filter(filter)
      @filters.push(filter)
    end

    def process(file)

    end

  end
end
