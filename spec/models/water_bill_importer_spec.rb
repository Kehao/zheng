#encoding: utf-8
require 'spec_helper'

describe WaterBillImporter do
  let(:admin)   {create(:admin)}
  before do
      SkyeyePower.company_class.has_many :elec_company_accounts,  class_name: "SkyeyePower::ElecCompanyAccount",dependent: :destroy
      SkyeyePower.company_class.has_many :water_company_accounts,  class_name: "SkyeyePower::WaterCompanyAccount",dependent: :destroy

    @company = admin.companies.create(
      name: "杭州盛华皮衣有限公司", 
      number: 330182000035091, 
      code: "70428744-1"
    )
  end
  it "import_bill/company exists" do

    row = ["杭州盛华皮衣有限公司","70428744-1",Time.now,12.0,100.0]
    expect{
      expect{
        expect{
          importer=WaterBillImporter.new
          importer.import_row(row)
        }.to change(SkyeyePower::CompanyAccount, :count).by(1)
      }.to change(SkyeyePower::Bill, :count).by(1)
    }.to change(Company, :count).by(0)

    expect{
      expect{
        expect{

          importer=ElecBillImporter.new
          importer.import_row(row)
        }.to change(SkyeyePower::CompanyAccount, :count).by(1)
      }.to change(SkyeyePower::Bill, :count).by(1)
    }.to change(Company, :count).by(0)
  end

  it "import_bill/company not exists" do
    row = ["company not exists","70428744-1",Time.now,12.0,100.0]
    expect{
      expect{
        expect{
          importer=WaterBillImporter.new
          importer.import_row(row)
        }.to change(SkyeyePower::CompanyAccount, :count).by(1)
      }.to change(SkyeyePower::Bill, :count).by(1)
    }.to change(Company, :count).by(1)

    expect{
      expect{
        expect{
          importer=ElecBillImporter.new
          importer.import_row(row)
        }.to change(SkyeyePower::CompanyAccount, :count).by(1)
      }.to change(SkyeyePower::Bill, :count).by(1)
    }.to change(Company, :count).by(0)

  end

end

