class SeekSpider < Spider
  include Rails.application.routes.url_helpers
  
  def crawl(crawl_sources_arg = [:idinfo])
    crawl_idinfo if [crawl_sources_arg].flatten.map!(&:to_sym).include? :idinfo

    seek.crawled = true
    seek.save
  end

  def seek
    sponsor
  end

  def crawl_idinfo
    self.data[:idinfo] = Sqider::Idinfo.where(idinfo_params)
  end

  def process_idinfo_data
    self.data[:idinfo].each do |cert_attrs|
      company = Company.create_with_cert(extract_cert_attrs(cert_attrs))
      company.trigger_notify_observers(:cert_info_crawled) unless company.new_record?
    end
  end

  def send_faye_channel
    seek.users.each do |user|
      FayeClient.publish("/user-#{user.id}", {:go_to_path => seek_path(seek), :status => :complete})
    end
  end

  private
  def idinfo_params
    @idinfo_params ||= if seek.company_number.present?
                         {key: seek.company_number, type: :number}
                       elsif seek.company_name.present?
                         {key: seek.company_name, type: :name}
                       else
                         {key: seek.person_name, type: :owner}
                       end
  end
end
