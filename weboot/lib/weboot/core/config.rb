module Weboot
  class Config

    def initialize(config, symbolize_names = false)
      @config = config
      @symbolize_names = symbolize_names
    end

    private def namize(name)
      (@symbolize_names) ? name.to_sym() : name.to_s()
    end

    def key?(name)
      @config.key?(namize(name))
    end

    def fetch(name)
      @config.fetch(namize(name))
    end

    def store(name, value)
      @config.store(namize(name), value)
    end

    def [](name)
      fetch(name)
    end

    def []=(name, value)
      store(name, value)
    end

  end
end
