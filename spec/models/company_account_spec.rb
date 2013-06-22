require 'spec_helper'

describe SkyeyePower::CompanyAccount do
  let(:company) { create(:company) }
  let(:admin)     {create(:admin)}

  it "find_or_create_unclassified_account" do
      SkyeyePower.company_class.has_many :elec_company_accounts,  class_name: "SkyeyePower::ElecCompanyAccount",dependent: :destroy
    expect { 
      account=SkyeyePower::ElecCompanyAccount.find_or_create_unclassified_account(company,admin)
    }.to change(SkyeyePower::ElecCompanyAccount, :count).by(1)
  end

end
