module Snapshot
  class Base
    attr_accessor :orig_url,:out_file_name,:command,:header
    class_attribute :base_out_path

   def logger
      Snapshot.logger
   end

   def self.logger
      Snapshot.logger
   end

    def build_command
      @command ||= [ 
        Snapshot.xvfb,
        Snapshot.cutycapt_path,
        Snapshot.cutycapt_args.call(url: orig_url,out: out_file_name,header: self.header)
      ].join(" ")
    end

    def run
      system command
      if File.exist?(out_file_name)
        if storage.store(out_file_name)
          self.logger.call(
            "\n" +
            "=== snapshot #{Time.now}\n" + 
            "=== [out-file-name: #{out_file_name}]\n" +
            "=== [path:#{storage.root}]\n" +
            "*** file exist: #{File.exist?(storage.retrieve(out_file_name))}" +
            "\n"
          )
          storage.retrieve(out_file_name)
        end
      else
        raise Errno::ENOENT,"out name: #{out_file_name}"
      end
    rescue Exception => ex
      self.logger.call "*** snapshot abored!"
      self.logger.call "*** errors: #{ex.message}"
    end

    def initialize(url,file_name,header=nil)
      @orig_url  = url
      @out_file_name = file_name.to_s + file_name_extension 
      @header = header
      build_command
    end

    def storage
      @storage ||= Storage::File.new
    end

    private
    def file_name_extension
      ".png"
    end

    def validate_options(options,keys)
      options.assert_valid_keys(keys)
      keys.each do |key|
        unless options[key] 
          raise NoKeyProvided, "No #{key} provided for cutycapt"
        end
      end
    end
  end
end
