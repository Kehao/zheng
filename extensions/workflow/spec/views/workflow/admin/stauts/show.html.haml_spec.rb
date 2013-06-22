require 'spec_helper'

describe "admin_stauts/show" do
  before(:each) do
    @staut = assign(:staut, stub_model(Admin::Staut))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
