require 'spec_helper'

describe "admin_company_accounts/show" do
  before(:each) do
    @company_account = assign(:company_account, stub_model(Admin::CompanyAccount))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
