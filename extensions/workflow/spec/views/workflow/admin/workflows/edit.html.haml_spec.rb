require 'spec_helper'

describe "admin_workflows/edit" do
  before(:each) do
    @workflow = assign(:workflow, stub_model(Admin::Workflow))
  end

  it "renders the edit workflow form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_workflows_path(@workflow), :method => "post" do
    end
  end
end
