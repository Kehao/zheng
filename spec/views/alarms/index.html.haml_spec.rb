require 'spec_helper'

describe "alarms/index" do
  before(:each) do
    assign(:alarms, [
      stub_model(Alarm),
      stub_model(Alarm)
    ])
  end

  it "renders a list of alarms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
