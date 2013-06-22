require 'spec_helper'

describe "admin_trackers/new" do
  before(:each) do
    assign(:tracker, stub_model(Admin::Tracker).as_new_record)
  end

  it "renders new tracker form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_trackers_path, :method => "post" do
    end
  end
end
