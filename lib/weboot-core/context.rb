module Weboot
  class Context

    TOPIC_CONTEXT = 'context'.freeze

    def initialize(page_config)
      @page = page_config
    end

    def get_proxy(key)
      case key.downcase!
      when 'site'
        Config.instance.site
      when 'page'
        @page
      when 'data'
        DataHub.instance.primary_datasource
      when key.start_with?('data@')
        _, datasource_name = key.split('@', 2)
        DataHub.instance.fetch(datasource_name)
      else
        raise IndexError, 'unknown top-level scope: %s' % (key)
      end
    end

    def forward(key, func, msg)
      begin
        proxy = get_proxy(key)
      rescue IndexError => e
        Weboot.logger.warn(TOPIC_CONTEXT, e.message)
        return nil
      end
      begin
        proxy.public_send(func, msg)
      rescue IndexError
        Weboot.logger.warn(TOPIC_CONTEXT, 'key not found: %s' % (key))
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
