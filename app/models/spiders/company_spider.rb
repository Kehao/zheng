class CompanySpider < Spider
  def self.crawl_resources
    @crawl_resources ||= [:idinfo, :court]
  end

  def self.schedule_all_to_run
    self.find_each(&:schedule_to_run)
  end

  def crawl_resources
    self.class.crawl_resources
  end

  def crawl(crawl_sources_arg = nil)
    crawl_resources_arr = crawl_sources_arg.try(:presence) || crawl_resources
    [crawl_resources_arr].flatten.map!(&:to_sym).each do |resource|
      send("crawl_#{resource}") 
    end
  end

  def company
    sponsor
  end

  def crawl_idinfo
    self.data[:idinfo] = Sqider::Idinfo.where(key: company.name, type: :name)
  end

  def crawl_court
    self.data[:court] = Sqider::Court.where(name: company.name)
  end

  def process_idinfo_data
    self.data[:idinfo].each do |cert_attrs|
      valid_cert_attrs = extract_cert_attrs(cert_attrs)
      next unless company.name.strip == valid_cert_attrs[:name].strip
      if company.cert
        company.cert.update_attributes(valid_cert_attrs)
      else
        company.create_cert(valid_cert_attrs)
      end
    end
    company.trigger_notify_observers(:cert_info_crawled)
  end

  def process_court_data
    self.data[:court].each do |crime_attrs|
      company.add_or_update_crime(extract_crime_attrs(crime_attrs))
    end
    company.trigger_notify_observers(:court_info_crawled)
  end

  def send_faye_channel
    company.trigger_notify_observers(:go_send_faye)
  end
end
