require 'asciidoctor/latex/core_ext/aliases'
require 'logger'

module Asciidoctor
  module Logger
    module_function

    def logger
      @logger ||= ::Logger.new(STDOUT).tap do |logger|
        logger.progname = 'asciidoctor-latex'
        logger.formatter = ->(severity, datetime, progname, msg) do
          "#{progname}: #{severity}: #{msg}"
        end
      end
    end

    def logger=(logger)
      @logger = logger
    end

    alias_class_method :log, :logger
  end
end
