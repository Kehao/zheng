require 'spec_helper'

describe "alarm_configs/show" do
  before(:each) do
    @alarm_config = assign(:alarm_config, stub_model(AlarmConfig))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
