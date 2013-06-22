require "spec_helper"

describe Admin::WorkflowsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin_workflows").should route_to("admin_workflows#index")
    end

    it "routes to #new" do
      get("/admin_workflows/new").should route_to("admin_workflows#new")
    end

    it "routes to #show" do
      get("/admin_workflows/1").should route_to("admin_workflows#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin_workflows/1/edit").should route_to("admin_workflows#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin_workflows").should route_to("admin_workflows#create")
    end

    it "routes to #update" do
      put("/admin_workflows/1").should route_to("admin_workflows#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin_workflows/1").should route_to("admin_workflows#destroy", :id => "1")
    end

  end
end
