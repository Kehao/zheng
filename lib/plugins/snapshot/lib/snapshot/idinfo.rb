module Snapshot
  class Idinfo < Base
    HEADER = "Referer:www.idinfo.cn/hzenterprise/hzEnterpriseSearch.action"
    VALID_KEYS= [:orig_url,:id]

    def initialize(options)
      validate_options(options,VALID_KEYS)

      out_dir_path = self.class.base_out_path

      @storage = Storage::File.new(out_dir_path)

      super(options[:orig_url],options[:id],HEADER)
    end

  end
end
