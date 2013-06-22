#encoding: utf-8
class ListFile < ActiveRecord::Base
  # 客户导入文件: excel xls file
  # 格式： 企业名称 | 法人代表姓名 | 法人身份证号| 营业执照编号 | 组织机构代码编号 | ...
  include Enumerize
  include Rails.application.routes.url_helpers
  attr_accessible :name, :clients_list, :import_status
  
  belongs_to :user
  has_many :company_clients, dependent: :nullify

  mount_uploader :clients_list, ClientsListUploader
  validates :clients_list, :user_id, presence: true

  after_commit :schedule_to_import, on: :create

  COLUMN = {
    company_name:    1,
    owner_name:      2,
    owner_number:    3,
    company_number:  4,
    company_code:    5
  }
  ROW_START = 2  # 第一行数据

  IMPORT_STATUS = {
    error:     -1,
    waiting:   0,
    importing: 1,
    complete:  2,
  }
  enumerize :import_status, in: IMPORT_STATUS, default: :waiting

  def import
    update_attributes(import_status: "importing")
    ## update view page into loading status
    # open do |file|
    #   sheet = file.worksheet 0
    #   sheet.each(ROW_START) do |row|
    #     import_row(row)
    #   end
    # end
    begin
      case clients_list.path[-3..-1]
      when 'xls'
        @file = Excel.new clients_list.path
      when 'lsx'
        @file = Excelx.new clients_list.path
      else
        @file = nil
      end
      @file.default_sheet = @file.sheets.first unless @file.nil?

      ROW_START.upto(@file.last_row) do |line|
        import_one_row_data line
      end
      update_attributes(import_status: "complete")
    rescue Exception => ex
      puts "#{Time.now} ======================"
      puts "#{ex}"
      update_attributes(import_status: "error")
    end
    ## update view page into complete status
    send_faye_channel
  end

  def send_faye_channel
    FayeClient.publish("/user-#{user.id}", {:go_to_path => company_clients_path, :status => :complete})
  end

  def open
    @file = Spreadsheet.open clients_list.path
    yield @file if block_given? 

    @file
  end

  # def import_row(row)
  #   return if row[0].blank?
  #   company = import_company(row)
  #   unless company.new_record? || company.owner
  #     import_company_owner(company, row) 
  #   end
  # end

  def import_one_row_data(line)
    return if @file.nil? && @file.cell(line, 1).blank?
    company = import_company(line)
    unless company.new_record? || company.owner
      import_company_owner(company, line) 
    end
  end

  def import_company(row)
    # company_attrs = {
    #   name:   row[COLUMN[:company_name]],
    #   number: row[COLUMN[:company_number]],
    #   code:   row[COLUMN[:company_code]]
    # }
    company_attrs = {
      name:   @file.cell(row, COLUMN[:company_name]),
      number: @file.cell(row, COLUMN[:company_number]),
      code:   @file.cell(row, COLUMN[:company_code])
    }
    
    if company_attrs[:number].present?
      company = Company.where(number: company_attrs[:number]).first
    elsif company_attrs[:code].present?
      company = Company.where(code: company_attrs[:code]).first
    elsif company_attrs[:name].present?
      company = Company.where(name: company_attrs[:name]).first
    else
      company = nil
    end

    if company.present?
      user.companies.push(company) unless user.companies.include?(company)
    else
      company = user.companies.create(company_attrs)
    end

    update_relation_to_listfile(company)
    company
  end

  def update_relation_to_listfile(company)
    cc = user.company_clients.where(company_id: company.id).first
    if cc.present?
      cc.list_file = self 
      cc.save
    end
    cc
  end

  def import_company_owner(company, row)
    # owner_attrs = {
    #   name:   row[COLUMN[:owner_name]],
    #   number: row[COLUMN[:owner_number]] 
    # }
    owner_attrs = {
      name:   @file.cell(row, COLUMN[:owner_name]),
      number: @file.cell(row, COLUMN[:owner_number])
    }
    if owner = Person.where(owner_attrs).first
      company.owner = owner
      company.save
    else
      owner = company.create_owner(owner_attrs)
      company.save
    end

    owner
  end

  private
  def schedule_to_import
    ListFileWorker.perform_async(self.id)
  end

end
