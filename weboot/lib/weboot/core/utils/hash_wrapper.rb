module Weboot
  class HashWrapper

    def initialize(inner, symbolize_names = false)
      @inner = inner
      @symbolize_names = symbolize_names
    end

    private def namize(name)
      (@symbolize_names) ? name.to_sym() : name.to_s()
    end

    def fetch(name)
      @inner.fetch(namize(name))
    end

    def store(name, value)
      @inner.store(namize(name), value)
    end

    def [](name)
      fetch(name)
    end

    def []=(name, value)
      store(name, value)
    end

  end
end
