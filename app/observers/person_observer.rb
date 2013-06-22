class PersonObserver < ActiveRecord::Observer
  def court_info_crawled(person)
    person.update_attributes({court_crawled: true})
  end

  def cert_info_crawled(person)
    person.update_attributes({idinfo_crawled: true})
  end
end
