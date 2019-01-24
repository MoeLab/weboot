require_relative 'logger'
require_relative 'site_config'
require_relative 'datasource_manager'

module Weboot
  class Context

    def initialize(page_config)
      @page_config = page_config
    end

    private def get_proxy(key)
      case key
      when 'site'
        Site.instance
      when 'page'
        @page_config
      when 'data'
        DataSourceManager.instance.primary_datasource_accessor
      when key.start_with?('data@')
        _, datasource_name = key.split('@', 2)
        DataSourceManager.instance.accessor(datasource_name)
      else
        raise IndexError, 'unknown top-level scope: %s' % (key)
      end
    end

    private def forward(key, func, msg)
      begin
        proxy = get_proxy(key)
      rescue IndexError => e
        Weboot.logger.warn(:context, e.message)
        return nil
      end
      begin
        proxy.public_send(func, msg)
      rescue IndexError
        Weboot.logger.warn(:context, 'key not found: %s' % (key))
        nil
      end
    end

    def fetch(name)
      key, name1 = name.split('.', 2)
      forward(key, :fetch, message(name1))
    end

    def store(name, value)
      key, name1 = name.split('.', 2)
      forward(key, :store, message(name1, value))
    end

  end
end
