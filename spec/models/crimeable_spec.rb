#encoding: utf-8
require 'spec_helper'

describe Crimeable do
  describe ".select_worst_court_status, court_status better by order in COURT_STATUS" do
    it 'select ["ok", "processing", "stopped"] is processing' do
      Company.select_worst_court_status(["ok", "processing", "stopped"]).should == "processing" 
    end
    it 'select ["ok", "error", nil] is ok' do
      Company.select_worst_court_status(["ok", "error", nil]).should == "ok" 
    end
  end
end

