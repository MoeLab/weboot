require_relative '../../aware'

require_relative '../config_reader'
require_relative '../config_stack'
require_relative '../site'

require_relative '../datasource_builder'
require_relative '../hook_builder'
require_relative '../filter_builder'
require_relative '../pipeline'

require_relative '../datasource_manager'
require_relative '../hook_manager'
require_relative '../filter_manager'
require_relative '../pipeline_manager'

module Weboot
  module Logic
    class << self

      def configure(root_dir)
        root_dir = File.expand_path root_dir

        config_stack = ConfigStack.new
        config_stack.push ConfigReader.read(File.join Weboot::SRC_DIR, 'default_site_config.yaml')
        config_stack.push ConfigReader.read(File.join root_dir, 'site_config.yaml')
        @site = Site.new config_stack.merge
        @site.root_dir = root_dir

        @datasource_manager = DataSourceManager.new
        @hook_manager = HookManager.new
        @filter_manager = FilterManager.new
        @pipeline_manager = PipelineManager.new

        plugin_dirs = @site['plugin-dirs']
        unless plugin_dirs.nil?
          plugin_dirs.each do |dirname|
            dirpath = (dirname.start_with? '/') ? dirname : File.expand_path(File.join @site.root_dir, dirname)
            next unless Dir.exist? dirpath
            load_plugins dirpath
          end
        end

        datasource_configs = @site['datasource-config']
        unless datasource_configs.nil?
          datasource_configs.each &method(:setup_datasource)

          primary_datasource = @site['primary-datasource']
          @datasource_manager.primary_datasource = primary_datasource
        end

        hook_configs = @site['hooks']
        unless hook_configs.nil?
          hook_configs.each &method(:setup_hook_builder)
        end

        filter_configs = @site['filters']
        unless filter_configs.nil?
          filter_configs.each &method(:setup_filter_builder)
        end

        pipeline_configs = @site['pipelines']
        unless pipeline_configs.nil?
          pipeline_configs.each &method(:setup_pipeline)
        end

        %w(after-scanning after-rendering after-writing).each do |phase|
          phase_hook_configs = @site[phase]
          next if phase_hook_configs.nil?
          phase_hook_configs.each do |settings|
            setup_phase_hook_builder(phase, settings)
          end
        end

        Weboot.logger.debug :configurator, 'site configured'
      end

      private def load_plugins(dirpath)
        Weboot.logger.debug :plugin, 'scan plugins in %s' % [dirpath]
        Dir.each_child(dirpath) do |filename|
          begin
            fullname = File.join dirpath, filename
            if Dir.exist? fullname
              Weboot.logger.debug :plugin, 'shot %s (dir)' % [filename]
              require File.join(fullname, 'weboot_manifest.rb')
            elsif filename.end_with? '.rb'
              Weboot.logger.debug :plugin, 'shot %s' % [filename]
              require fullname
            end
          rescue LoadError => e
            Weboot.logger.error :config_reader, 'plugin load failed: %s' % [e.message]
          end
        end
      end

      private def setup_datasource(name, settings)
        builder = DataSourceBuilder.new name
        builder.settings = settings
        @datasource_manager.add name, builder.instance
      end

      private def setup_hook_builder(name, settings)
        builder = HookBuilder.new name
        builder.settings = settings
        @hook_manager.register name, builder
      end

      private def setup_filter_builder(name, settings)
        builder = FilterBuilder.new name
        builder.settings = settings
        @filter_manager.register name, builder
      end

      private def setup_pipeline(settings)
        name = settings['name']

        suffixes = settings['suffix']
        suffixes = (suffixes || []).split(' ')

        filters = settings['filters']
        filters = (filters || []).map do |filter_settings|
          @filter_manager.get_builder filter_settings
        end

        pipeline = Pipeline.new name, suffixes, filters
        @pipeline_manager.add pipeline
      end

      private def setup_phase_hook_builder(phase, settings)
        @hook_manager.add_phase_hook phase, @hook_manager.get_builder(settings)
      end

    end
  end
end
