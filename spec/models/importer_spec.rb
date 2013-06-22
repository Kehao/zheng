#encoding: utf-8
require 'spec_helper'

describe Importer do
  let(:admin)   {create(:admin)}
  before do
    @company = Company.create(
      name: "杭州盛华皮衣有限公司", 
      number: 330182000035091, 
      code: "70428744-1"
    )
  end

  it "parser" do
    importer = Importer.new
    importer.user = admin
    importer.parser = RooExcel.new(File.expand_path("./spec/files/客户导入测试模板-通过.xls")) 
    importer.save
  end



end
