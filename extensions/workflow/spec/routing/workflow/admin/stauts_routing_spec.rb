require "spec_helper"

describe Admin::StautsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin_stauts").should route_to("admin_stauts#index")
    end

    it "routes to #new" do
      get("/admin_stauts/new").should route_to("admin_stauts#new")
    end

    it "routes to #show" do
      get("/admin_stauts/1").should route_to("admin_stauts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin_stauts/1/edit").should route_to("admin_stauts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin_stauts").should route_to("admin_stauts#create")
    end

    it "routes to #update" do
      put("/admin_stauts/1").should route_to("admin_stauts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin_stauts/1").should route_to("admin_stauts#destroy", :id => "1")
    end

  end
end
