module Weboot
  class << self

    private def vars_merge_hash(current, other)
      # __clear inside is prior to __merge outside
      clear = other.fetch('__clear', false)
      return other if clear
      current.merge(other) do |key, cur_value, new_value|
        if cur_value.is_a?(Hash) and new_value.is_a?(Hash)
          merge = other.fetch('__merge', nil)
          # merge Hash by default
          merge = current.fetch('__merge', true) if merge.nil?
          if merge
            vars_merge_hash(cur_value, new_value)
          else
            new_value
          end
        elsif cur_value.is_a?(Array) and new_value.is_a?(Array)
          merge = other.fetch(key + '__merge', nil)
          # not merge Array by default
          merge = current.fetch(key + '__merge', false) if merge.nil?
          if merge
            # Array#+ returns a new array, while Array#concat has side-effect
            cur_value + new_value
          else
            new_value
          end
        else
          new_value
        end
      end
    end

    def vars_merge(current, other)
      raise ArgumentError, 'merging is not a hash: %s' % [current.class] unless current.is_a?(Hash)
      return current if other.nil?
      raise ArgumentError, 'merged is not a hash: %s' % [other.class] unless other.is_a?(Hash)
      vars_merge_hash(current, other)
    end

    def var_resolve(name, vars)
      keys = name.split('.')
      keys.inject(vars) do |var, key|
        if var.is_a?(Hash)
          begin
            var.fetch(key)
          rescue KeyError => e
            throw KeyError, 'not found in hash: %s[%s] on \'%s\'' % [var.inspect, key, name]
          end
        elsif var.is_a?(Array)
          begin
            var.fetch(key.to_i())
          rescue ArgumentError, IndexError => e
            throw IndexError, 'not found in array: %s[%s] on \'%s\'' % [var.inspect, key, name]
          end
        end
      end
    end

    def var_substitute(format, vars)
      format.gsub(/\${([^}]+)}/) do |x|
        self.var_resolve(x, vars)
      end
    end

  end
end
