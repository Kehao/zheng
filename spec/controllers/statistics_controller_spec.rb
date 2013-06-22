require 'spec_helper'

describe StatisticsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'global'" do
    it "returns http success" do
      get 'global'
      response.should be_success
    end
  end

  describe "GET 'detail'" do
    it "returns http success" do
      get 'detail'
      response.should be_success
    end
  end

end
