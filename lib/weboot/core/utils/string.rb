module Weboot

  def parse_string(format, vars)
    format.gsub(/\${([^}]+)}/) do |x|
      keys = x.split('.')
      keys.inject(vars) do |var, key|
        break x unless var.key?(key)
        var[key]
      end
    end
  end

end
