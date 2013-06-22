require 'spec_helper'

describe "admin_trackers/index" do
  before(:each) do
    assign(:admin_trackers, [
      stub_model(Admin::Tracker),
      stub_model(Admin::Tracker)
    ])
  end

  it "renders a list of admin_trackers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
