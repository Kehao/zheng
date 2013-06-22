require 'spec_helper'

describe "admin_institutions/new" do
  before(:each) do
    assign(:institution, stub_model(Admin::Institution).as_new_record)
  end

  it "renders new institution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_institutions_path, :method => "post" do
    end
  end
end
