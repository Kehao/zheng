require 'spec_helper'

describe "admin_stauts/index" do
  before(:each) do
    assign(:admin_stauts, [
      stub_model(Admin::Staut),
      stub_model(Admin::Staut)
    ])
  end

  it "renders a list of admin_stauts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
