require 'yaml'

module Weboot
  class ConfigReader

    def read_site_config(text)
      yaml = ::YAML.load(text)
      site_config = SiteConfig.new(yaml)

      datasource_config = site_config['datasource-config']
      datasource_config.each do |name, settings|
        datasource = setup_datasource(name, settings)
        DataSourceManager.instance.add(name, datasource)
      end
      primary_datasource = site_config['primary-datasource']
      DataSourceManager.instance.primary_datasource = primary_datasource

      hook_config = site_config['hooks']
      hook_config.each do |name, settings|
        builder = setup_hook_builder(name, settings)
        Config.instance.register_hook(name, builder)
      end

      filter_config = site_config['filters']
      filter_config.each do |name, settings|
        builder = setup_filter_builder(name, settings)
        Config.instance.register_filter(name, builder)
      end

      %w(after-scanning after-rendering after-writing).each do |phase|
        phase_hook_configs = site_config[phase]
        next if phase_hook_configs.nil?
        phase_hook_configs.each do |phase_hook_config|
          hook_builder = setup_phase_hook_builder(phase_hook_config)
          Config.instance.add_phase_hook(phase, hook_builder)
        end
      end

      Config.site = site_config
    end

    def setup_datasource(name, settings)
      builder = DataSourceBuilder.new(name)
      builder.settings = settings
      builder.instance
    end

    def setup_hook_builder(name, settings)
      builder = HookBuilder.new(name)
      builder.settings = settings
      builder
    end

    def setup_filter_builder(name, settings)
      builder = FilterBuilder.new(name)
      builder.settings = settings
      builder
    end

    def setup_phase_hook_builder(settings)
      if settings.is_a?(String)
        name = settings
        config = nil
      else
        name = settings[:name]
        config = settings[:config]
      end
      hook_builder = Config.instance.get_hook_builder(name)
      hook_builder.clone
      hook_builder.push_config(config)
      hook_builder
    end

  end
end
