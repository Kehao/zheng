#encoding: utf-8
module Reporter
  extend Configurable
 
  ###
  # === rails logger path
  configure do |config|
    config.log_path = File.join(File.dirname(Rails.configuration.paths["log"].first),'reporter.log')
  end


  def self.logger
    @logger ||= begin
                  log = Reporter::Logger.new(config.log_path)
                  log.progname = 'skyeye_reporter'
                  log
                end
  end
end

