module Snapshot
  class Court < Base
    VALID_KEYS= [:orig_url,:party_number,:case_id]
    attr_accessor *VALID_KEYS

    def initialize(options)
      validate_options(options,VALID_KEYS)

      out_dir_path = File.expand_path(options[:party_number],self.class.base_out_path)

      @storage = Storage::File.new(out_dir_path)

      super(options[:orig_url],options[:case_id])
    end
  end

end



