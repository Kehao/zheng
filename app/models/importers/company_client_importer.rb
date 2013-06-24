#encoding: utf-8
class CompanyClientImporter < Importer

  has_many :company_clients, foreign_key:"importer_id", dependent: :destroy
  has_many :companies, foreign_key:"importer_id"#dependent: :destroy

  COLUMN = %w(company_name company_number owner_name owner_number)
  TITLE  = %w(企业名称 工商注册号 法人姓名 法人身份证号)

  def faye_go_to_path
    "/company_clients/new?tab=upload-list-box"
  end

  #def parser
  #  @parser ||= RooExcel.new(self,"/Users/qiu/Downloads/企业模板.xls") 
  #end

  def check_import_file
    unless parser.title.map(&:strip) == TITLE 
      raise "请使用客户导入模板导入!属性为#{TITLE.join(",")}"
    end
  end


  def import_row(row)
    company_attrs,owner_attrs = company_client_attrs(row)

    import_company_and_company_client(company_attrs) do |company, company_client|
      import_company_owner(company, owner_attrs) 
    end
    row_valid?
  end


  def company_client_attrs(row)
    company_attrs = {
      name:   s(row[COLUMN.index("company_name")]),
      number: s(row[COLUMN.index("company_number")]),
      owner_name: s(row[COLUMN.index("owner_name")])
    }
    owner_attrs = {
      name:   s(row[COLUMN.index("owner_name")]),
      number: s(row[COLUMN.index("owner_number")])
    }
    [company_attrs,owner_attrs]
  end

end

