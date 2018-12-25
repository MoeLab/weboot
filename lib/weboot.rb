# frozen_string_literal: true

# rubygems
require 'rubygems'

# stdlib
require 'forwardable'
require 'fileutils'
require 'time'
require 'English'
require 'pathname'
require 'logger'
require 'set'
require 'csv'
require 'json'

# third-party
require 'safe_yaml/load'

module Weboot
  autoload :CONFIG, 'weboot-core/config'
  autoload :VERSION, 'weboot-core/version'

  class << self

    def logger=(writer)
      @logger = LogAdapter.new(writer, (ENV['JEKYLL_LOG_LEVEL'] || :info).to_sym)
    end

  end
end
