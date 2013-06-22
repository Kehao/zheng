# encoding: utf-8
class ClientPersonRelationship < ActiveRecord::Base
  include ClientRelationship
  attr_accessible :person, :relate_type, :hold_percent, :desc, :person_name, :person_number,:importer_secure_token,:start_date,:expiration_date

  belongs_to :client, polymorphic: true   # client --- CompanyClient/PersonClient
  belongs_to :person

  # 无论是否建立了person对象，person_name都必须存在，这样与只有一个person_name的情况统一
  validates :person_name, presence: true

  # 由于enumerize的原因，Rails本身的uniqueness验证无法用，因为relate_type的值与数据库存储的值不相同
  validate :person_uniqueness

  after_create :create_person

  # 当赋值person时，自动赋值person_name, person_number
  def person=(person)
    self.person_name = person.try(:name) unless person_name
    self.person_number = person.try(:number) unless person_number
    super(person)
  end

  def to_export_array
    target_company = self.client.company 
    associated_person = self.person

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
        "个人",
        associated_person && associated_person.name || self.person_name,
        associated_person && associated_person.number || "",
        "",
        self.hold_percent,
        self.desc
      ]
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
  def create_person
    unless person
      self.build_person(name: person_name, number: person_number)
      self.save
    end
  end

  def person_uniqueness
    if self.class.where(client_id: client_id, client_type: client_type, relate_type: relate_type.try(:value), person_name: person_name, person_number: person_number).exists?
      errors.add(:person, :taken) and return 
    end

    if person_id.present? && self.class.where(client_id: client_id, client_type: client_type, relate_type: relate_type.try(:value), person_id: person_id).exists?
      errors.add(:person, :taken) and return
    end
  end
end
