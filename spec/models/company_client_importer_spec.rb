#encoding: utf-8
require 'spec_helper'

describe CompanyClientImporter do
  let(:admin)   {create(:admin)}
  before do
    @company = Company.create(
      name: "杭州盛华皮衣有限公司", 
      number: 330182000035091, 
      code: "70428744-1"
    )
  end
  it "search_company" do
    company_attrs = {
      name:"  杭州盛华皮衣有限公司",
      number: 330182000035013, 
      code: "70428744-11"
    }
    company=Importer.search_company(company_attrs)
    company.should_not be_nil
  end

  it "import_company_and_company_client/company exists" do
    company_attrs = {
      name:"杭州盛华皮衣有限公司",
      number: 330182000035091, 
      code: "70428744-1"
    }
    expect{
      expect{
      importer=CompanyClientImporter.new
      importer.user=admin
      importer.import_company_and_company_client(company_attrs)
    }.to change(Company, :count).by(0)
    }.to change(CompanyClient, :count).by(1)
  end

  it "import_company_and_company_client/company not exists" do
    company_attrs = {
      name:"杭州盛华皮衣有限公司not exist"
    }
    expect{
      expect{
      importer=CompanyClientImporter.new
      importer.user=admin
      importer.import_company_and_company_client(company_attrs)
    }.to change(Company, :count).by(1)
    }.to change(CompanyClient, :count).by(1)

  end

  it "import owner" do
    company_attrs = {
      name:"杭州盛华皮衣有限公司not exist"
    }
    owner_attrs = {
      name:   "test",
      number: "331002198508234913"
    }

    expect{
      expect{
      expect{
      importer=CompanyClientImporter.new
      importer.user=admin
      importer. import_company_and_company_client(company_attrs) do |company,company_client|
        importer.import_company_owner(company,owner_attrs)
      end
    }.to change(Company, :count).by(1)
    }.to change(CompanyClient, :count).by(1)
    }.to change(Person, :count).by(1)


  end

  it "class  ProgressRate" do
    importer=CompanyClientImporter.new
    pr = Importer::ProgressRate.new(importer,100)
    pr.start do
      pr.increment_counter
      pr.increment_counter
      pr.counter.should == 2
      pr.cost_time.should_not == 0 
    end
  end

  it "import data/通过" do
    CompanyClient.delete_all

    expect{
      expect{
      importer = CompanyClientImporter.new
      importer.user = admin
      importer.parser = RooExcel.new(importer,File.expand_path("./spec/files/客户导入测试模板-通过.xls")) 
      importer.save
      importer.import
      importer.importer_exception_temps.size.should == 0
    }.to change(Company, :count).by(13)
    }.to change(CompanyClient, :count).by(14)
  end

  it "import_company_and_company_client/importer_company有出错项" do
    CompanyClient.delete_all

    expect{
      expect{
      importer = CompanyClientImporter.new
      importer.user = admin
      importer.parser = RooExcel.new(importer,File.expand_path("./spec/files/客户导入测试模板-不通过.xls")) 
      importer.save
      importer.import
      importer.importer_exception_temps.size.should == 1
      importer.row_exception_msgs.should == []
    }.to change(Company, :count).by(11)
    }.to change(CompanyClient, :count).by(12)
  end

  

end
