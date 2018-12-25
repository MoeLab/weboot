module Weboot
  class Logger
    attr_reader :writer
    attr_reader :default_level

    LEVELS = {
      :debug => ::Logger::DEBUG,
      :info => ::Logger::INFO,
      :notice => ::Logger::WARN,
      :warn => ::Logger::WARN,
      :error => ::Logger::ERROR,
      :fatal => ::Logger::FATAL,
    }.freeze

    def initialize(writer, default_level = :info)
      @writer = writer
      @default_level = default_level
    end

    def writable?(level, topic)
      true
    end

    def write(level, topic, msg, &block)
      return false unless writable?(level, topic)
      writer.public_send(level, message(topic, msg, &block))
    end

    def debug(topic, msg, &block)
      write(:debug, topic, msg, &block)
    end

    def info(topic, msg, &block)
      write(:info, topic, msg, &block)
    end

    def notice(topic, msg, &block)
      write(:notice, topic, msg, &block)
    end

    def warn(topic, msg, &block)
      write(:warn, topic, msg, &block)
    end

    def error(topic, msg, &block)
      write(:error, topic, msg, &block)
    end

    def fatal(topic, msg, &block)
      write(:fatal, topic, msg, &block)
    end

  end
end
