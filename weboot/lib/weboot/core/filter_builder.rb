require_relative 'abstract_builder'

module Weboot
  class FilterBuilder < AbstractBuilder

    def interface_type
      Filter::FilterInterface
    end

  end
end
