require 'spec_helper'

describe "admin_institutions/show" do
  before(:each) do
    @institution = assign(:institution, stub_model(Admin::Institution))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
