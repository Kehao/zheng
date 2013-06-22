require 'spec_helper'

describe "admin_company_accounts/index" do
  before(:each) do
    assign(:admin_company_accounts, [
      stub_model(Admin::CompanyAccount),
      stub_model(Admin::CompanyAccount)
    ])
  end

  it "renders a list of admin_company_accounts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
