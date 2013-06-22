require "spec_helper"

describe Admin::InstitutionsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin_institutions").should route_to("admin_institutions#index")
    end

    it "routes to #new" do
      get("/admin_institutions/new").should route_to("admin_institutions#new")
    end

    it "routes to #show" do
      get("/admin_institutions/1").should route_to("admin_institutions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin_institutions/1/edit").should route_to("admin_institutions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin_institutions").should route_to("admin_institutions#create")
    end

    it "routes to #update" do
      put("/admin_institutions/1").should route_to("admin_institutions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin_institutions/1").should route_to("admin_institutions#destroy", :id => "1")
    end

  end
end
