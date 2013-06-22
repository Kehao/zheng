#encoding: utf-8
module WorkerHelper
  XVFB = "xvfb-run --server-args='-screen 0, 1024x768x24'"

  CUTYCAPT_EXEC = "#{Rails.root}/lib/CutyCapt/CutyCapt"
  CUTYCAPT_ARGS = ->(url,out,options=""){"--url=\"%s\" --js-can-open-windows=on --delay=5000 #{options} --out=\"%s\"" % [url,out]}

  module Base
    def process(url,out)
      system "#{XVFB} #{CUTYCAPT_EXEC} #{CUTYCAPT_ARGS.call(url,out)}"
    end

   def run_one(obj)
      return true unless obj.snapshot_path.blank?
      check_path(obj) do |root,out|
        if process(obj.orig_url,out)
          obj.snapshot_path=out
          obj.save
        end
      end
    end

  def perform_all(class_name)
      class_name.constantize.where(snapshot_path:nil).each do |obj|
        run_one(obj) 
      end
    end
  end


  module Idinfo
    include Base
    extend self
    COMPANY_ROOT          = ->(id){ "#{Rails.root}/public/certs/#{id}" }
    COMPANY_IDINFO_OUT    = ->(id){ "#{COMPANY_ROOT.call(id)}/#{id}.png" }
    COMPANY_IDINFO_HEADER = "--header=Referer:www.idinfo.cn/hzenterprise/hzEnterpriseSearch.action"

    def process(url,out)
      system "#{XVFB} #{CUTYCAPT_EXEC} #{CUTYCAPT_ARGS.call(url,out,COMPANY_IDINFO_HEADER)}"
    end

    def check_path(cert)
      root_path=COMPANY_ROOT.call(cert.regist_id)
       out_path=COMPANY_IDINFO_OUT.call(cert.regist_id)
      FileUtils.mkdir_p root_path  unless File.exist?(root_path)
      yield root_path,out_path
    end
   
    def perform_one(cert_id)
      cert = Cert.find(cert_id)
      run_one(cert) 
    end
  end

  module Court
    include Base
    extend self
    PERSON_ROOT      = ->(id){ "#{Rails.root}/public/crimes/#{id}" }

    def conv_path(path)
      path =~ /第(\d*)号/
       $1
    end

    def check_path(crime)
      root_path = PERSON_ROOT.call(crime.party_number)
      out_path  = "#{root_path}/#{conv_path crime.case_id}.png"
      FileUtils.mkdir_p root_path  unless File.exist?(root_path)
      yield root_path,out_path
    end

    def perform_one(crime_id)
      crime = Crime.find(crime_id)
      run_one(crime) 
    end
  end
end
