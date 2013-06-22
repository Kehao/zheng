require 'spec_helper'

describe "admin_institutions/index" do
  before(:each) do
    assign(:admin_institutions, [
      stub_model(Admin::Institution),
      stub_model(Admin::Institution)
    ])
  end

  it "renders a list of admin_institutions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
