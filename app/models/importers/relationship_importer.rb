#encoding: utf-8
class RelationshipImporter < Importer
  has_many :client_company_relationships, foreign_key:"importer_secure_token", primary_key: "secure_token", dependent: :destroy
  has_many :client_person_relationships, foreign_key:"importer_secure_token", primary_key: "secure_token", dependent: :destroy

  ROW = %w(target_type target_object relate_type associated_type associated_object hold_percent desc)  
  ROWPOSITION = [0, 1..3, 4, 5, 6..8, 9, 10]

  ROWNAME = [
    "type",
    "company_name/person_name",
    "company_number/person_number",
    "company_code",
    "relate_type",
    "type",
    "company_name/person_name",
    "company_number/person_number",
    "company_code",
    "hold_percent",
    "desc"
  ] 

  TITLE = [
    "企业/个人",
    "公司名称/个人姓名",
    "企业工商注册号/个人身份证号",
    "组织机构代码",
    "关系类型",
    "企业/个人",
    "公司名称/个人姓名",
    "企业工商注册号/个人身份证号",
    "组织机构代码",
    "持股比例",
    "备注"
  ]
  Relationship = %w(法人 股东 担保人 被担保人 子公司 债权人 债务人 其它)
  RelationshipValue = %w(owner shareholder guarantor guarantee sub_company debtor creditor other)


  def row_attrs
    @row_attrs ||= begin
                     ROW.inject({}) do |attrs,info| 
                       i = ROWPOSITION[ROW.index(info)]
                       attrs[info] = [ROWNAME[i], TITLE[i], ROWPOSITION[i]]
                       attrs
                     end
                   end
  end


  def faye_go_to_path
    "/company_clients/new?tab=upload-list-box2"
  end

  def import_row(row)
    attrs = self.class.relationship_attrs(row)
    args = [
      attrs[:target_company_attrs] || attrs[:target_person_attrs],
      attrs[:relationship],
      attrs[:associated_company_attrs] || attrs[:associated_person_attrs]
    ]
    self.public_send(attrs[:method_name],*args)
    row_valid?
  end

  def company_relationship_company(target_company_attrs,relationship,associated_company_attrs)
    associated_company = search_or_create_company(associated_company_attrs)
    if row_valid?
      import_company_and_company_client(target_company_attrs) do |company,company_client|
        import_client_company_relationship(company_client,relationship,associated_company)
      end
    end
    row_valid?
  end

  def company_relationship_person(target_company_attrs,relationship,associated_person_attrs)
    associated_person = search_or_create_person(associated_person_attrs)
    if row_valid?
      import_company_and_company_client(target_company_attrs) do |company,company_client|
        import_client_person_relationship(company_client,relationship,associated_person)
      end
    end
    row_valid?
  end

  def person_relationship_company(target_person_attrs,relationship,associated_company_attrs)
    add_row_exception_msgs("person_relationship_company has not implemented !!!")
  end

  def person_relationship_person(target_person_attrs,relationship,associated_person_attrs)
    add_row_exception_msgs("person_relationship_person has not implemented !!!")
  end

  def parser
    @parser ||= begin 
                  roo_excel = RooExcel.new(self,file.path)
                  roo_excel.row_start = 3
                  roo_excel 
                end
  end

  class << self
    def relationship_attrs(row)
      attrs={}
      target_type   = s(cell(row,"target_type"))
      target_object = cell(row,"target_object")

      associated_type   = s(cell(row,"associated_type"))
      associated_object = cell(row,"associated_object")

      if entity_type_company?(target_type)
        attrs[:target_company_attrs] = {
          name: s(target_object[0]),
          number: s(target_object[1]),
          code: s(target_object[2])
        }
        attrs[:method_name] = ["company"]
      else
        attrs[:target_person_attrs] = {
          name: s(target_object[0]),
          number: s(target_object[1]) 
        }
        attrs[:method_name] = ["person"]
      end

      attrs[:relationship] = {
        :relate_type => s(cell(row,"relate_type")),
        :hold_percent => cell(row,"hold_percent"),
        :desc => s(cell(row,"desc"))
      }
      attrs[:method_name] << "relationship"

      if entity_type_company?(associated_type)
        attrs[:associated_company_attrs] = {
          name: s(associated_object[0]),
          number: s(associated_object[1]),
          code: s(associated_object[2])
        }
        attrs[:method_name] << "company"
      else
        attrs[:associated_person_attrs] = {
          name: s(associated_object[0]),
          number: s(associated_object[1]) 
        }
        attrs[:method_name] << "person"
      end
      attrs[:method_name] = attrs[:method_name].join("_")
      attrs
    end

    def relate_type(type_string)
      RelationshipImporter::RelationshipValue[RelationshipImporter::Relationship.index(type_string)]
    end

    def entity_type_company?(str)
      {"企业" => true,"个人" =>false}[str]
    end

    def cell(row,info)
      row[ROWPOSITION[ROW.index(info)]]
    end
  end
end
#["企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", "法人", "个人", "方兴东", "3410021985082346155", nil, nil, nil]
#["企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", "股东", "个人", "楼晓东", "3410021985082346155", nil, 50.0, nil]
#["企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", "被担保人", "个人", "方兴东", "3410021985082346155", nil, 50.0, nil]
#["企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", "担保人", "企业", "中安担保", "788837606", "75629645-4", nil, nil]
#["企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", "被担保人", "企业", "博客中国", "788837606", "75629645-4", nil, nil]
#["企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", "子公司", "企业", "义乌全球网", "788837606", "75629645-4", nil, nil]
#["企业", "博客中国", "788837606", "75629645-4", "债权人", "企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", nil, nil]
#["企业", "杭州商友全球网信息技术有限公司 ", "330724197412130015", "78178589-0", "债务人", "企业", "博客中国", "788837606", "75629645-4", nil, nil]
#["个人", "邱克浩", "3310021985082346134", nil, "担保人", "个人", "项理", "3410021985082346155", nil, 20.0, nil]
#["个人", "test", "3310021985082346134", nil, "担保人", "企业", "test111", "330724197412136615", nil, 20.0, nil]
#
#attrs_hash = ROW.inject({}) do |attrs,info|
#  i = ROWPOSITION[ROW.index(info)]
#  attrs[info] = row[i]
#  attrs
#end
#


