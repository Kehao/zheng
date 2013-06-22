#encoding: utf-8
require 'logger'

module Reporter 
  class Logger 
    module Severity
      DEBUG   = 0
      INFO    = 1
      WARN    = 2
      ERROR   = 3
      FATAL   = 4
      UNKNOWN = 5
    end
    include Severity

    def initialize(log, level = INFO)
      unless log.respond_to?(:write)
        unless File.exist?(File.dirname(log))
          FileUtils.mkdir_p(File.dirname(log))
        end
      end
      @log = open_logfile log
      @log.formatter = Pretty.new
      self.level = level 
    end

    class Pretty < ::Logger::Formatter
      def call(severity, time, progname, message)
        super(severity, time.utc.in_time_zone('Beijing'), progname, message)
      end
    end

    Severity.constants.each do |severity|
      class_eval <<-EOT, __FILE__, __LINE__ + 1
        def #{severity.downcase}(message = nil, progname = nil, &block) # def debug(message = nil, progname = nil, &block)
          add(#{severity}, message, progname, &block)                   #   add(DEBUG, message, progname, &block)
        end                                                             # end

        def #{severity.downcase}?                                       # def debug?
      #{severity} >= level                                              #   DEBUG >= level
        end                                                             # end
      EOT
    end

    def close
      @log.close
    end

    def add(severity, message = nil, progname = nil, &block)
      @log.add(severity, message, progname, &block)
    end

    #    class Pretty < Formatter
    #      def call(severity, time, progname, message)
    #        super(severity, time.in_time_zone("Beijing"), progname, message)
    #      end
    #    end

    def level
      @log.level
    end

    def level=(l)
      @log.level = l
    end

    def progname=(name)
      @log.progname=name
    end

    private
    def open_logfile(log)
      ::Logger.new log
    end

  end
end
