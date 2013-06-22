require 'spec_helper'

describe "admin_stauts/new" do
  before(:each) do
    assign(:staut, stub_model(Admin::Staut).as_new_record)
  end

  it "renders new staut form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_stauts_path, :method => "post" do
    end
  end
end
