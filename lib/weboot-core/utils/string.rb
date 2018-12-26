module Weboot

  def parse_string(format, vars)
    format.gsub(/\${([^}]+)}/) do |x|
      keys = x.split('.')
      var = vars
      keys.each do |key|
        break x unless var.key?(key)
        var = var[key]
      end
    end
  end

end
