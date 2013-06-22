require 'spec_helper'

describe "alarms/edit" do
  before(:each) do
    @alarm = assign(:alarm, stub_model(Alarm))
  end

  it "renders the edit alarm form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => alarms_path(@alarm), :method => "post" do
    end
  end
end
