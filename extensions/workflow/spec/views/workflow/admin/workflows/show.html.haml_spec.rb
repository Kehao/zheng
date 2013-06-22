require 'spec_helper'

describe "admin_workflows/show" do
  before(:each) do
    @workflow = assign(:workflow, stub_model(Admin::Workflow))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
