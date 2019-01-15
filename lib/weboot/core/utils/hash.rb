module Weboot
  class << self

    private def merge_iter(container, key, new_value)
      if new_value.is_a?(Hash)
        if new_value.fetch(:_append, false)
          cur_value = container[key]
          if cur_value.is_a?(Hash)
            return merge(cur_value, new_value)
          end
        end
      end
      container.store(key, new_value)
      container
    end

    def merge(current, other)
      other.each do |k, v|
        merge_iter(current, k, v)
      end
      current
    end

  end
end
