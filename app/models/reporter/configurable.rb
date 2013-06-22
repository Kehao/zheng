module Reporter
  module Configurable
    def config
      @config ||= Reporter::Config.new 
    end

    def configure
      yield config
    end 
  end

  class Config
    attr_accessor :enabled

    def initialize(options = {})
      @enabled = true
      @options = options
    end

    private

    def method_missing(name, *args, &blk)
      if name.to_s =~ /=$/
        @options[$`.to_sym] = args.first
      elsif @options.key?(name)
        @options[name]
      else
        super
      end
    end

  end

end
