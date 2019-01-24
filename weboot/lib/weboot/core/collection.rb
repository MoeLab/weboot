require_relative 'config_stack'

module Weboot
  class Collection

    MATCH_FUNCS = {
      :true => -> (_, _) {true},
      :equal => -> (ref, subject) {ref.eql? subject},
      :start_with => -> (prefix, subject) {subject.start_with? prefix},
      :end_with => -> (suffix, subject) {subject.end_with? suffix},
      :regex => -> (regex, subject) {regex.match? subject}
    }

    def initialize(parent, name, config)
      @parent = parent
      @name = name
      @config = config
      @rules = []

      parse_include_rules
    end

    private def parse_include_rules
      return if @config.nil?
      include_policy = @config['include-rules']
      return if include_policy.nil?
      parse_rules true, include_policy['force-include']
      parse_rules false, include_policy['exclude']
    end

    private def parse_rules(policy, rules)
      return if rules.nil?
      rules.each do |rule|
        parse_rule policy, rule
      end
    end

    private def parse_rule(policy, rule)
      if rule.is_a? String
        inheritable = false
      elsif rule.is_a? Hash
        inheritable = rule['inheritable'] || false
        rule = rule['rule']
      else
        raise ArgumentError, 'invalid rule type: %s' % [rule.class]
      end

      if rule.start_with? '/'
        if rule.end_with? '/'
          rule = {
            :func => MATCH_FUNCS[:regex],
            :ref => Regexp.new(rule[1..-2]),
          }
        else
          raise ArgumentError, 'invalid rule syntax: %s' % [rule]
        end
      else
        rule = {
          :func => MATCH_FUNCS[:equal],
          :ref => rule
        }
      end
      rule[:policy] = policy
      rule[:inheritable] = inheritable

      @rules.append rule
    end

    private def dig_recursively(config_names, func_sym, default)
      ret = @config.dig(*config_names)
      return ret unless ret.nil?
      return default if @parent.nil?
      ret = @parent.public_send(func_sym)
      (ret.nil?) ? default : ret
    end

    def enabled?
      enabled = @config['enabled']
      enabled || enabled.nil?
    end

    def default_policy
      dig_recursively %w(include-rules default), :default_policy, true
    end

    def include?(filename, inheritable_only = false)
      @rules.each do |rule|
        next if inheritable_only and not rule[:inheritable]
        return rule[:policy] if rule[:func].call rule[:ref], filename
      end
      unless @parent.nil?
        ret = @parent.include? filename, true
        return ret unless ret.nil?
      end
      (inheritable_only) ? nil : default_policy
    end

    def merge_page_config
      return @page_config_cache unless @page_config_cache.nil?
      config_stack = ConfigStack.new
      config_stack.push @parent.merge_page_config unless @parent.nil?
      config_stack.push @config['page'] unless @config.nil?
      @page_config_cache = config_stack.merge
    end

  end
end
