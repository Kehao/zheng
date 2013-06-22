#encoding: utf-8
class CompanyClientImporter < Importer

  has_many :company_clients, foreign_key:"importer_secure_token", primary_key: "secure_token", dependent: :destroy
  has_many :companies, foreign_key:"importer_secure_token", primary_key:"secure_token"#, dependent: :destroy

  COLUMN = %w(company_name owner_name owner_number company_number company_code)
  TITLE  = %w(企业名称 法人代表姓名 法人身份证号 营业执照编号 组织机构代码编号)

  def faye_go_to_path
    "/company_clients/new?tab=upload-list-box"
  end

  def row_pre_validations(row)
   # if s(row[COLUMN.index("company_name")]).blank?
   #   add_row_exception_msgs("#{TITLE[COLUMN.index("company_name")]}不能为空!")
   # end
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
      code:   s(row[COLUMN.index("company_code")]),
      owner_name: s(row[COLUMN.index("owner_name")])
    }
    owner_attrs = {
      name:   s(row[COLUMN.index("owner_name")]),
      number: s(row[COLUMN.index("owner_number")])
    }
    [company_attrs,owner_attrs]
  end

end

