require 'spec_helper'

describe "admin_institutions/edit" do
  before(:each) do
    @institution = assign(:institution, stub_model(Admin::Institution))
  end

  it "renders the edit institution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_institutions_path(@institution), :method => "post" do
    end
  end
end
