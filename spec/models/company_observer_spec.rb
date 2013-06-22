require 'spec_helper'

describe CompanyObserver do
  describe "#valify_info" do
    let(:cert){ build(:cert) }
    let(:crime){ build(:crime) }
    let(:company){ build(:company) }


    it "should warning when court_crawled and cert info is blank" do
      company.idinfo_crawled = true
      company.save
      company.valify_cert_status
      company.idinfo_status.should == "important"
    end

    it "do not do anything when court_crawled is false" do
      company.idinfo_crawled = false
      company.save
      company.valify_cert_status
      company.idinfo_status.should == nil
    end

    it "get success when cert created" do
      company1 = build(:company, cert: cert) 
      company1.idinfo_crawled = true
      company1.save
      company1.valify_cert_status
      company1.idinfo_status.should == "success"
    end

    it "do not do anything when court_crawled is false" do
      company.court_crawled = false
      company.save
      company.valify_court_status
      company.court_status.should == nil
    end

    it "update its court_status to success when court_crawled and nothing got" do
      company.court_crawled = true
      company.save
      company.valify_court_status
      company.court_status.should == "success"
    end

    it "shuold warning important when the client has crime" do
      company.court_crawled = true
      company.save
      company.crimes << crime
      company.valify_court_status
      company.court_status.should == "important"
    end

  end
end
