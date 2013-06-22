require 'spec_helper'

describe "admin_company_accounts/new" do
  before(:each) do
    assign(:company_account, stub_model(Admin::CompanyAccount).as_new_record)
  end

  it "renders new company_account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_company_accounts_path, :method => "post" do
    end
  end
end
