require 'spec_helper'

describe Spider do
  describe "validates" do
    let (:company) { create(:company) }
    let (:spider) { create(:company_spider, sponsor: company) }

    it "sponsor should be uniqe" do
      spider = CompanySpider.new(sponsor: company)
      spider.should_not be_valid
      spider.should have(1).error_on(:sponsor_id)
    end

    it "sponsor_id sponsor_type should be presence" do
      spider = CompanySpider.new
      spider.should have_at_least(1).error_on(:sponsor_id)
      spider.should have_at_least(1).error_on(:sponsor_type)
    end
  end

  describe ".reschedule_waiting_to_run" do
    let!(:company) { create(:company) }

    before do
      SpiderWorker.jobs.clear
    end

    it "should schedult waiting spiders to run with sidekiq"  do
      expect { 
        Spider.reschedule_waiting_to_run
      }.to change(SpiderWorker.jobs, :size).by(1)
    end
  end
  describe ".reschedule_company_waiting_to_run" do
    let!(:company) { create(:company) }

    before do
      SpiderWorker.jobs.clear
    end

    it "should schedult company waiting spiders to run with sidekiq"  do
      expect { 
        Spider.reschedule_company_waiting_to_run
      }.to change(SpiderWorker.jobs, :size).by(1)
    end
  end
end
