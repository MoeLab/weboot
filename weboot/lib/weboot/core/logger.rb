require 'logger'

module Weboot
  class Logger
    attr_reader :writer
    attr_reader :default_level

    LEVELS = {
      :trace => ::Logger::DEBUG,
      :debug => ::Logger::DEBUG,
      :info  => ::Logger::INFO,
      :warn  => ::Logger::WARN,
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
      puts '%s [%5s] %s | %s' % [Time.new.strftime('%H:%M:%S'), level.upcase, topic, msg]
      # writer.public_send(level, message(topic, msg, &block))
    end

    def trace(topic, msg, &block)
      write(:trace, topic, msg, &block)
    end

    def debug(topic, msg, &block)
      write(:debug, topic, msg, &block)
    end

    def info(topic, msg, &block)
      write(:info, topic, msg, &block)
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
