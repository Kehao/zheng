#encoding: utf-8
require 'spec_helper'

describe RelationshipImporter do
  let(:admin)   {create(:admin)}
  before do
    @company = Company.create(
      name: "杭州盛华皮衣有限公司", 
      number: 330182000035091, 
      code: "70428744-1"
    )
  end

  it "company_relationship_company" do
   target_company_attrs = {
      :name=>"杭州商友全球网信息技术有限公司", 
      :number=>"330724197412130015", 
      :code=>"78178589-0"
    }
   associated_company_attrs = {
     :name=>"博客中国", 
     :number=>"788837606", 
     :code=>"75629645-4"
   }
   relationship = {
     :relate_type=>"债务人", 
     :hold_percent=>nil, 
     :desc=>""
   }
   expect{
     expect{
     expect{
     importer = RelationshipImporter.new
     importer.user=admin
     importer.company_relationship_company(target_company_attrs,relationship,associated_company_attrs)
   }.to change(ClientCompanyRelationship,:count).by(1)
   }.to change(Company, :count).by(2)
   }.to change(CompanyClient, :count).by(1)
  end

it "company_relationship_company/target_company_attrs not valid" do
   target_company_attrs = {
      :name=>"", 
      :number=>"330724197412130015", 
      :code=>"78178589-0"
    }
   associated_company_attrs = {
     :name=>"博客中国", 
     :number=>"788837606", 
     :code=>"75629645-4"
   }
   relationship = {
     :relate_type=>"债务人", 
     :hold_percent=>nil, 
     :desc=>""
   }
   expect{
     expect{
     expect{
     expect{
     importer = RelationshipImporter.new
     importer.user=admin
     roo = RooExcel.new(importer,File.expand_path("./spec/files/关联方导入模板.xls"))
     roo.row_start = 3
     importer.parser = roo  
     importer.import
   }.to change(ClientCompanyRelationship,:count).by(5)
   }.to change(Person, :count).by(3)
   }.to change(Company, :count).by(4)
   }.to change(CompanyClient, :count).by(2)
   p Company.all.map &:name 
   p ClientCompanyRelationship.all.map &:relate_type
  end

end

