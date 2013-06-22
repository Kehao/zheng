#encoding: utf-8
require "snapshot/version"

module Snapshot
  class NoKeyProvided < Exception; end

  mattr_accessor :xvfb
  @@xvfb = "xvfb-run --server-args='-screen 0, 1024x768x24'" 

  mattr_accessor :cutycapt_path

  mattr_accessor :cutycapt_args

  @@cutycapt_args = ->(*args) do
    options = args.extract_options!

    url = (args.first || options[:url]).try(:to_s)
    if url.nil? and !options.has_key?(:url)
      raise NoKeyProvided, "No url provided for cutycapt"
    end

    url = "http://" + url unless url =~ /http:\/\//
      args_string = ["--url=\"%s\"" % url]

    options[:js_can_open_window] ||= true
    args_string.push("--js-can-open-windows=on") if options[:js_can_open_window]

    options[:header] ||= false
    args_string.push("--header=#{options[:header]}") if options[:header]

    if !options[:out]
      raise NoKeyProvided, "No out provided for cutycapt"
    end
    args_string.push("--out=%s" % options[:out]) 

    args_string.join(" ")
  end

  def self.path
    Dir.pwd
  end

  def self.rails3?
    File.exists?(File.join(path, 'script', 'rails'))
  end

  def self.logger
    @logger ||= begin
                  logger_path = File.join(File.dirname(Rails.configuration.paths["log"].first),'snapshot.log')
                  log = Reporter::Logger.new(logger_path)
                  log.method(:info)
                rescue
                  method(:puts)
                end
  end
end

require "snapshot/storage"
require "snapshot/base"
require "snapshot/court"
require "snapshot/idinfo"

if Snapshot.rails3? 
  Snapshot.cutycapt_path = "#{Snapshot.path}/lib/CutyCapt/CutyCapt" 
  Snapshot::Court.base_out_path = "#{Snapshot.path}/public/crimes"  
  Snapshot::Idinfo.base_out_path = "#{Snapshot.path}/public/certs"  
else
  rails_root = File.expand_path('../../../../../', __FILE__)
  Snapshot.cutycapt_path = "#{rails_root}/lib/CutyCapt/CutyCapt" 
  Snapshot::Court.base_out_path = "#{rails_root}/public/crimes"  
  Snapshot::Idinfo.base_out_path = "#{rails_root}/public/certs"  
end

unless  File.exist?(Snapshot.cutycapt_path)
  raise "Please check your cutycapt path !!!"
end



