require 'spec_helper'

describe "alarms/new" do
  before(:each) do
    assign(:alarm, stub_model(Alarm).as_new_record)
  end

  it "renders new alarm form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => alarms_path, :method => "post" do
    end
  end
end
