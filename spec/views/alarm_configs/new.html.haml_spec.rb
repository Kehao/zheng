require 'spec_helper'

describe "alarm_configs/new" do
  before(:each) do
    assign(:alarm_config, stub_model(AlarmConfig).as_new_record)
  end

  it "renders new alarm_config form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => alarm_configs_path, :method => "post" do
    end
  end
end
