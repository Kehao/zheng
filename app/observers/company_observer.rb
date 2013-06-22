class CompanyObserver < ActiveRecord::Observer
  def court_info_crawled(company)
    company.update_attributes({court_crawled: true})
  end

  def cert_info_crawled(company)
    company.update_attributes({idinfo_crawled: true})
    company.valify_cert_status
  end

  def go_send_faye(company)
    
  end
end
