require 'spec_helper'

describe "admin_trackers/edit" do
  before(:each) do
    @tracker = assign(:tracker, stub_model(Admin::Tracker))
  end

  it "renders the edit tracker form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_trackers_path(@tracker), :method => "post" do
    end
  end
end
