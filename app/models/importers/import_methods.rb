#encoding: utf-8
require 'active_support/concern'

module ImportMethods
  extend ActiveSupport::Concern

  module ClassMethods
    # = company_attrs
    #   {
    #    name:"  杭州盛华皮衣有限公司",
    #    number: 330182000035013, 
    #    code: "70428744-11"
    #   }
    # name必须,只搜索公司名字 13/3/11 
    # [:number,:name,:code2
    # return company || nil
    #
    def search_company(company_attrs)
      return nil if company_attrs[:name].blank?
      Company.where(name: company_attrs[:name].strip).first
    end

    # = person_attrs
    #   {
    #     :name=>"邱克浩", 
    #     :number=>"3310021985082346134"
    #   }
    # name与number必须,根据名字和身分证号匹配 13/3/18 
    # return person || nil
    #
    def search_person(person_attrs)
      return nil if person_attrs.blank? or person_attrs.values.all?(&:blank?) 
      Person.where(name:person_attrs[:name],number:person_attrs[:number]).first
    end

    def search_or_create_company(company_attrs,importer)
      company = search_company(company_attrs)

      unless company 
        company = import_company(company_attrs,importer)
      end

      importer.end_import(company)
    end

    def search_or_create_person(person_attrs,importer)
      person = search_person(person_attrs)
      unless person
        person = import_person(person_attrs,importer)
      end
      importer.end_import(person)
    end

    def import_company(company_attrs,importer)
      company = Company.new(company_attrs)
      company.importer_id = importer && importer.id || nil
      company.create_way = Company::CREATE_WAY[:import]
      company.save
      company
    end

    def import_person(person_attrs,importer)
      person = Person.create(person_attrs)
      #TODO
      #person.importer_secure_token = self.secure_token
      #person.create_way = Company::CREATE_WAY[:import]
    end
  end


  #
  #  instance_methods
  #
  def search_or_create_company(company_attrs)
    self.class.search_or_create_company(company_attrs,self)
  end

  def search_or_create_person(person_attrs)
    self.class.search_or_create_person(person_attrs,self)
  end

  def import_company(company_attrs)
    self.class.import_company(company_attrs,self)
  end

  def import_person(person_attrs)
    self.class.import_person(person_attrs,self)
  end

  def import_company_client(company)
    company_client = self.user.company_clients.where(company_id:company.id).first

    unless company_client
      company_client = self.user.company_clients.new
      company_client.company = company
      company_client.importer_id = self.id
      company_client.save
    end
    end_import(company_client)
  end

  def import_company_owner(company, owner_attrs)
    if owner = Person.where(owner_attrs).first
      company.owner = owner
      company.save
    else
      owner = company.create_owner(owner_attrs)
      company.save
    end
  end

  def import_client_company_relationship(company_client,relationship_attrs,company)
    relate_type = RelationshipImporter.relate_type(relationship_attrs[:relate_type])
    rela = company_client.company_relationships.create(
      :importer_id => self.id,
      :desc => relationship_attrs[:desc],
      :hold_percent => relationship_attrs[:hold_percent],
      :relate_type => relate_type,
      :company => company
    )
    end_import(rela)
  end

  def import_client_person_relationship(company_client,relationship_attrs,person)
    relate_type = RelationshipImporter.relate_type(relationship_attrs[:relate_type])
    rela = company_client.person_relationships.create(
      :importer_id => self.id,
      :desc => relationship_attrs[:desc],
      :hold_percent => relationship_attrs[:hold_percent],
      :relate_type => relate_type,
      :person => person
    )
    end_import(rela)
  end

  def end_import(record)
    if record.new_record?
      msg = record.errors.full_messages.join(',')
      human_name = record.class.model_name.human
      add_row_exception_msgs("导入[#{human_name}]失败:#{msg}")
    end
    record
  end

  def import_data_source_and_data_item(company_client,data_source_attrs,data_item_attrs)
    data_source = search_or_create_company_client_data_source(company_client,data_source_attrs)

    if row_valid?
      import_data_item(data_source,data_item_attrs)
    end
    row_valid?
  end

  def search_or_create_company_client_data_source(company_client,data_source_attrs)
    unless data_source_attrs[:identify].blank?
      data_source = company_client.elec_data_sources.where(data_source_attrs).first
    else
      data_source = company_client.elec_data_sources.default
    end
    unless data_source
      data_source = import_data_source(company_client,data_source_attrs)
    end
    data_source 
  end

  def import_data_source(company_client,data_source_attrs)
      data_source = company_client.elec_data_sources.create(data_source_attrs.merge(:importer_id=>self.id)) 
      end_import(data_source)
  end

  def import_data_item(data_source,data_item_attrs)
      data_item=data_source.data_items.create(data_item_attrs.merge(:importer_id=>self.id,:status=>"other")) 
      end_import(data_item)
  end

  def import_company_and_company_client(company_attrs)
    company = search_or_create_company(company_attrs)

    if row_valid? 
      company_client = import_company_client(company)
    end

    if row_valid? && block_given?
      yield company,company_client 
    end

    row_valid? 
  end

end
