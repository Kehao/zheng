#encoding: utf-8
class PowerBillImporter < Importer

  has_many :bills,class_name:"SkyeyePower::Bill",foreign_key:"importer_secure_token",primary_key:"secure_token",dependent: :destroy
  has_many :companies,class_name:"company",foreign_key:"importer_secure_token",primary_key:"secure_token"

  COLUMN = %w(company_name company_code record_time amount cost) 
  TITLE  = %w(客户名称 组织机构代码 月份(年/月/日) 使用量 金额)

  def  row_pre_validations(row)
    #company_name
    #不能为空
    i = COLUMN.index("company_name")
    if s(row[i]).blank?
      add_row_exception_msgs("[#{TITLE[i]}]不能为空!")
    end

    #record_time
    #不能为空,类型为Date
    i = COLUMN.index("record_time")
    if row[i].blank?
      add_row_exception_msgs("[#{TITLE[i]}]不能为空!")
    else
      unless row[i].is_a?(Date) or row[i].to_s =~ /\d{4}-\d{2}-\d{2}/
        add_row_exception_msgs("[#{TITLE[i]}]必须是日期!")
      end
    end

    #amount,cost
    #不能为空,且是浮点数或者整数
    ["amount","cost"].each do |title|
      i = COLUMN.index(title)
      if row[i].blank?
        add_row_exception_msgs("[#{TITLE[i]}]不能为空!")
      else
        unless row[i].is_a?(Float) or row[i].is_a?(Integer) or !row[i].to_f.eql?(0.0) 
          add_row_exception_msgs("[#{TITLE[i]}]必须是浮点数或者整数!")
        end
      end
    end
  end

  def power_bill_attrs(row)
    { company_code: s(row[COLUMN.index("company_code")]),
      company_name: s(row[COLUMN.index("company_name")]),
      record_time:  row[COLUMN.index("record_time")],
      amount:       row[COLUMN.index("amount")],
      cost:         row[COLUMN.index("cost")]}
  end

  def import_row(row)
    bill_attrs = power_bill_attrs(row) 
    company = Importer.search_company(:name => bill_attrs[:company_name] )
    if company 
      import_bills_when_company_exist(company,bill_attrs)
    else
      import_bills_when_company_not_exist(bill_attrs)
    end
  end

  def import_bills_when_company_exist(company,bill_attrs)
    account = account_class.find_or_create_unclassified_account(company)
    unless account.new_record?
      bill = account.bills.new(
        bill_attrs.dup.extract!(:record_time,:amount,:cost)
      )
      bill.importer_secure_token = self.secure_token
      bill.save
    end
  end

  def import_bills_when_company_not_exist(bill_attrs)
    company = import_company(name:bill_attrs[:company_name],code:bill_attrs[:company_code])
    if  !company.new_record?
      import_bills_when_company_exist(company,bill_attrs)
    end
  end
end
