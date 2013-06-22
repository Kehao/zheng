# encoding: utf-8
class ClientCompanyRelationship < ActiveRecord::Base
  include ClientRelationship
  attr_accessible :company, :relate_type, :hold_percent, :desc,:importer_secure_token,:start_date,:expiration_date
  belongs_to :client, polymorphic: true   # :client => CompanyClient/PersonClient
  belongs_to :company

  validates :company, presence: true

  # 由于enumerize的原因，Rails本身的uniqueness验证无法用，因为relate_type的值与数据库存储的值不相同
  validate :company_uniqueness


  def to_export_array
    target_company = self.client.company 
    associated_company = self.company
    unless self.relate_type.blank?
      relate_type = 
        if i=RelationshipImporter::RelationshipValue.index(self.relate_type)
          RelationshipImporter::Relationship[i]
        else
          "其它"
        end
      ["企业",
        target_company.name,
        target_company.number,
        target_company.code,
        relate_type,
        "企业",
        associated_company && associated_company.name || "",
        associated_company && associated_company.number || "",
        associated_company && associated_company.code || "",
        self.hold_percent,
        self.desc]
    else
      [ "企业",
        target_company.name,
        target_company.number,
        target_company.code,
        "自身案件信息",
        "",
        "",
        "",
        "",
        "",
        "" ]
    end
  end

  private

  def company_uniqueness 
    if self.new_record? && self.class.where(client_id: client_id, client_type: client_type, relate_type: relate_type.try(:value), company_id: company_id).exists?
      errors.add(:company, :taken)
    end
  end
end
