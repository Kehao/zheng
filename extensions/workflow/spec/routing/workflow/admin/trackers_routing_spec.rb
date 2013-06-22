require "spec_helper"

describe Admin::TrackersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin_trackers").should route_to("admin_trackers#index")
    end

    it "routes to #new" do
      get("/admin_trackers/new").should route_to("admin_trackers#new")
    end

    it "routes to #show" do
      get("/admin_trackers/1").should route_to("admin_trackers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin_trackers/1/edit").should route_to("admin_trackers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin_trackers").should route_to("admin_trackers#create")
    end

    it "routes to #update" do
      put("/admin_trackers/1").should route_to("admin_trackers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin_trackers/1").should route_to("admin_trackers#destroy", :id => "1")
    end

  end
end
