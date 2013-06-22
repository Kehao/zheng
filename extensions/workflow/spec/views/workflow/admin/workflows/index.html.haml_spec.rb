require 'spec_helper'

describe "admin_workflows/index" do
  before(:each) do
    assign(:admin_workflows, [
      stub_model(Admin::Workflow),
      stub_model(Admin::Workflow)
    ])
  end

  it "renders a list of admin_workflows" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
