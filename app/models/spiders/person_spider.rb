class PersonSpider < Spider
  def crawl(crawl_sources_arg = [:court])
    crawl_resources_arr = crawl_sources_arg.try(:presence) || [:court]
    [crawl_resources_arr].flatten.map!(&:to_sym).each do |resource|
      send("crawl_#{resource}") 
    end
  end

  def person
    sponsor
  end

  def crawl_idinfo
    self.data[:idinfo] = Sqider::Idinfo.where(key: person.name, type: :owner)
  end

  def crawl_court
    self.data[:court] = Sqider::Court.where(name: person.name, card_number: person.number)
  end

  def process_idinfo_data
    self.data[:idinfo].each do |cert_attrs|
      company = Company.create_with_cert(extract_cert_attrs(cert_attrs))
      company.trigger_notify_observers(:cert_info_crawled) unless company.new_record?
    end
  end

  def process_court_data
    self.data[:court].each do |crime_attrs|
      person.add_or_update_crime(extract_crime_attrs(crime_attrs))
    end
    person.trigger_notify_observers(:court_info_crawled)
  end

end
