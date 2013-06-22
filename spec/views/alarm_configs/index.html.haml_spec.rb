require 'spec_helper'

describe "alarm_configs/index" do
  before(:each) do
    assign(:alarm_configs, [
      stub_model(AlarmConfig),
      stub_model(AlarmConfig)
    ])
  end

  it "renders a list of alarm_configs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
