#encoding: utf-8
class Exporter < ActiveRecord::Base
  include Enumerize

  FORMATS       = ['excel']
  CONTENT_TYPES = ['crime','relationship'] # 内容类型(法务等)
  SUFFIX        = {'excel' => 'xls'}

  ALLOWED_OPTIONS = [
    "closed", 
    "processing", 
    "other", 
    "region_code", 
    "regist_date_after",
    "client_attrs",
    "target_object",
    "relationship_attrs",
    "associated_type",
    "associated_object",
    "crime_attrs",
    "crime_enable"
  ]

  attr_accessible :file_path, :format, :options, :content_type, :status, :created_at

  # options描诉了具体的导出细节
  serialize  :options, Hash

  validates :format,       inclusion: {in: FORMATS}
  validates :content_type, inclusion: {in: CONTENT_TYPES}

  belongs_to :user

  enumerize :status,       in: {waiting: 0, success: 1, failed: 2}, default: :waiting
  enumerize :format,       in: FORMATS, default: 'excel'
  enumerize :content_type, in: CONTENT_TYPES, default: 'crime'

  before_save :slice_allowed_options

  def destroy
    if file_path.present? && File.file?(absolute_file_path)
      File.delete absolute_file_path
    end
  ensure
    super
  end

  def export
    self.file_path = File.join(export_dir, file_name)
    mk_export_dir
    send("export_#{content_type}")
  end

  def export_relationship
    path ||= File.join(Rails.root, file_path)
    export_result = 
      if self.options[:crime_enable].eql?("relationship_crime")
        Exporter::Excel.new(sheet_relationship_crime_header, sheet_relationship_crime_body, path, :sheet_name => "关联方案件信息导出").export
      elsif self.options[:crime_enable].eql?("crime_relationship")
        Exporter::Excel.new(sheet_crime_relationship_header, sheet_crime_relationship_body, path, :sheet_name => "案件信息关联方导出").export
      else
        Exporter::Excel.new(sheet_relationship_header, sheet_relationship_body, path, :sheet_name => "关联方导出").export
      end
    self.status = export_result ? 'success' : 'failed'
  ensure
    self.save
    export_result
  end

  def sheet_relationship_crime_header
    sheet_relationship_header + %W(案件号 案件状态 立案时间 执行人 执行标的 执行法院 获取时间 信息来源) 
  end

  def sheet_crime_relationship_header
    sheet_relationship_crime_header
  end

  def need_export_target_object_crimes?(last_client,client)
    self.options[:crime_attrs][:with_target_object_crimes].eql?("1") &&
      last_client && 
      last_client.is_a?(CompanyClient) &&
      (client.present? && (last_client.id != client.id) || client.nil?)
  end

  def export_last_client_crimes(last_client,client=nil)
    if need_export_target_object_crimes?(last_client,client)
      last_target_object_crimes = last_client.company.all_crimes
      unless last_target_object_crimes.blank?
        yield new_relationship_for(last_client),last_target_object_crimes
      end
    end
  end

  def relationship_crimes
    relationships = search_current_user_relationships(true)
    relationships.sort! do |r1,r2| r1.client_id <=> r2.client_id end
    if self.options[:crime_attrs][:regist_date_after]
      regist_date_after = ["crimes.regist_date >= ?", self.options[:crime_attrs][:regist_date_after]]
    end

    if status = self.options[:crime_attrs][:status]
      status = nil if status.eql?("all") 
    end

    last_client = nil
    relationships.each do |relationship|
      crimes = []
      if relationship.is_a? ClientCompanyRelationship
        if relationship.company
          crimes = relationship.company.all_crimes    
        end
      else
        if relationship.person
          crimes = relationship.person.crimes    
        end
      end
      unless crimes.blank?
        crimes = crimes.where(regist_date_after)
        if status
          crimes = crimes.where(:state => Crime::STATE_LIST[status.intern])
        end
      end

      export_last_client_crimes(last_client,relationship.client) do |new_relationship,crimes|
        yield new_relationship,crimes
      end

      last_client = relationship.client

      yield relationship,crimes
    end

    export_last_client_crimes(last_client,nil) do |new_relationship,crimes|
      yield new_relationship,crimes
    end
  end

  def new_relationship_for(last_client)
    last_target_object_relationship = last_client.company_relationships.new
    last_target_object_relationship.company = last_client.company
    last_target_object_relationship.relate_type = nil
    last_target_object_relationship
  end


  def sheet_relationship_crime_body
    rows = []
    relationship_crimes do |relationship,crimes|
      unless crimes.blank?
        crimes.each do |crime|
          rows << relationship.to_export_array + row_crime(crime)
        end
      else
        rows << relationship.to_export_array 
      end
    end
    rows
  end

  def sheet_crime_relationship_body
    rows = []
    last_client = nil
    relationship_crimes do |relationship,crimes|
      if relationship.persisted? || (relationship.new_record? && last_client && (relationship.client.id == last_client.id))
        unless crimes.blank?
          crimes.each do |crime|
            rows << relationship.to_export_array + row_crime(crime)
          end
          last_client = relationship.client
        end

      end
    end
    rows
  end

  def row_crime(crime)
    [crime.case_id, crime.case_state, crime.reg_date, crime.party_name, crime.apply_money, crime.court_name, crime.created_at.strftime("%Y-%m-%d"), crime.orig_url]
  end


  def export_crime
    path ||= File.join(Rails.root, file_path)

    court_statuses = (Company.court_status.values - ['ok'])
    companies_crimes = []

    if options["region_code"] == '000000'
      companies = user.companies
    elsif options["region_code"].to_s == '-1'
      companies = user.companies.search(:region_code_blank => true).result
    else
      code = AreaCN::Code.new(options["region_code"])
      companies = user.companies.search(:region_code_start => code.prefix).result
    end

    companies.by_court_status(court_statuses.map(&:value)).each do |company|
      crimes = []
      incharge_crimes = company.all_crimes.where("crimes.regist_date >= ?", options["regist_date_after"])
      incharge_crimes.each do |crime|
        crimes << crime if crime_meet_options(crime)
      end
      companies_crimes << [company, crimes] if crimes.present?
    end

    export_result = Exporter::Excel.new(sheet_crime_header, sheet_crime_body(companies_crimes), path, :sheet_name => "企业案件").export

    self.status = export_result ? 'success' : 'failed'
  ensure
    self.save
    export_result
  end

  def file_name
    @file_name ||= "#{user.name}_#{content_type}_#{self.created_at.strftime("%Y-%m-%d-%H-%M-%S")}.#{file_suffix}"
  end

  def file_suffix
    SUFFIX[format]
  end

  def export_dir
    @export_dir ||= "exports/#{self.content_type}/#{format}"
  end

  def absolute_file_path
    @absolute_file_path ||= File.join(Rails.root, file_path)
  end

  private
  def slice_allowed_options
    options.slice!(*ALLOWED_OPTIONS)
  end

  def mk_export_dir
    FileUtils.mkdir_p(File.join(Rails.root, export_dir))
  end

  def crime_meet_options(crime)
    return true if is_true(options['all'])
    return true if is_true(options['closed']) && crime.category_state == 'closed'
    return true if is_true(options['processing']) && crime.category_state == 'processing'
    return true if is_true(options['other']) && crime.category_state == 'other'

    false
  end

  def sheet_relationship_header
    RelationshipImporter::TITLE
  end

  def search_current_user_relationships(return_object = false)
    self.options[:client_attrs][:user_id] = self.user_id
    search_relationships(return_object)
  end

  def search_relationships(return_object = false)
    relationships = []
    search_company_relationships = search_person_relationships = false
    if self.options[:associated_type].eql?("company")
      search_company_relationships = true
    end

    if self.options[:associated_type].eql?("person")
      search_person_relationships = true
    end

    if self.options[:associated_type].eql?("all")
      search_company_relationships = true
      search_person_relationships = true
    end

    if search_company_relationships 
      ClientCompanyRelationship.search_company_relationships({}.merge(self.options)).each do |rs|
        if return_object
          relationships << rs 
        else
          relationships << rs.to_export_array
        end
      end
    end
    if search_person_relationships 
      ClientCompanyRelationship.search_person_relationships({}.merge(self.options)).each do |rs|
        if return_object
          relationships << rs 
        else
          relationships << rs.to_export_array
        end
      end
    end

    relationships
  end

  def sheet_relationship_body
    search_current_user_relationships
  end

  def sheet_crime_header
    %W(企业名称 法人代表姓名 法人身份证号 营业执照编号 组织机构号码 案件号 案件状态 立案时间 执行人 执行标的 执行法院 获取时间 信息来源) 
  end

  def sheet_crime_body(companies_crimes)
    rows = []
    companies_crimes.each do |company_crimes|
      company = company_crimes[0]
      crimes  = company_crimes[1]

      cells = [company.name, company.owner_name, company.owner.try(:number), company.number, company.code]

      crimes.each do |crime|
        row = cells + [crime.case_id, crime.case_state, crime.reg_date, crime.party_name, crime.apply_money, crime.court_name, crime.created_at.strftime("%Y-%m-%d"), crime.orig_url] 
        rows << row
      end
    end

    rows
  end


  class Excel
    attr_reader :path, :header, :body, :options

    # === Options
    # [:sheet_name]
    def initialize(header, body, path, options = {})
      @header = header
      @body = body
      @path = path
      @options = options
    end

    def sheet_name(num = 1)
      options[:sheet_name] || "sheet#{num}"
    end

    def export
      return false if @body.blank?
      new_workbook(path) do |book|
        sheet = book.create_worksheet name: sheet_name

        sheet_header(sheet, header)

        sheet_body(sheet, body)
      end

      true
    end

    private
    def new_workbook(path, &block)
      book = Spreadsheet::Workbook.new

      yield book

      dir = path[/(.*\/).*$/, 1]
      FileUtils.mkdir_p(dir)

      book.write(path)
    end

    def sheet_header(sheet, header)
      sheet.row(0).concat header
    end

    def sheet_body(sheet, body)
      body.each_with_index do |row_cells, index|
        sheet.row(index + 1).push(*row_cells)
      end
    end
  end
end
