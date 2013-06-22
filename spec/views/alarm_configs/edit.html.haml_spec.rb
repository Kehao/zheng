require 'spec_helper'

describe "alarm_configs/edit" do
  before(:each) do
    @alarm_config = assign(:alarm_config, stub_model(AlarmConfig))
  end

  it "renders the edit alarm_config form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => alarm_configs_path(@alarm_config), :method => "post" do
    end
  end
end
