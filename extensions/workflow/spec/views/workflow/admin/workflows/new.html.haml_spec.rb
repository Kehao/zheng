require 'spec_helper'

describe "admin_workflows/new" do
  before(:each) do
    assign(:workflow, stub_model(Admin::Workflow).as_new_record)
  end

  it "renders new workflow form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_workflows_path, :method => "post" do
    end
  end
end
