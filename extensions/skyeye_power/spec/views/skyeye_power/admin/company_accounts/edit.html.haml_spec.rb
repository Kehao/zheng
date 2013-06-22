require 'spec_helper'

describe "admin_company_accounts/edit" do
  before(:each) do
    @company_account = assign(:company_account, stub_model(Admin::CompanyAccount))
  end

  it "renders the edit company_account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_company_accounts_path(@company_account), :method => "post" do
    end
  end
end
