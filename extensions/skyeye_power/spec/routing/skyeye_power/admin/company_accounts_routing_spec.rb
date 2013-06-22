require "spec_helper"

describe Admin::CompanyAccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin_company_accounts").should route_to("admin_company_accounts#index")
    end

    it "routes to #new" do
      get("/admin_company_accounts/new").should route_to("admin_company_accounts#new")
    end

    it "routes to #show" do
      get("/admin_company_accounts/1").should route_to("admin_company_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin_company_accounts/1/edit").should route_to("admin_company_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin_company_accounts").should route_to("admin_company_accounts#create")
    end

    it "routes to #update" do
      put("/admin_company_accounts/1").should route_to("admin_company_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin_company_accounts/1").should route_to("admin_company_accounts#destroy", :id => "1")
    end

  end
end
