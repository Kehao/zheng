require 'spec_helper'

describe "admin_trackers/show" do
  before(:each) do
    @tracker = assign(:tracker, stub_model(Admin::Tracker))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
