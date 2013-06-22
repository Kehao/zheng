module ClientRelationship
  extend ActiveSupport::Concern

  # ee 表示被动类似于employee的意思，
  # er/or 表示主动类似于employer的意思
  RELATE_TYPES = { 
    owner:          1, 
    shareholder:    2, 
    sub_company:    3, 
#    branch_company: 4, 
#    parent_company: 5,
    guarantee:      6, 
    guarantor:      7, 
    debtor:         8,
    creditor:       9,
    other:          0
  }


  included do
    include Enumerize unless included_modules.include?(Enumerize)
    enumerize :relate_type, in: RELATE_TYPES

    validates_numericality_of :hold_percent, greater_than: 0, less_than_or_equal_to: 1.0, allow_nil: true
    validates :relate_type, presence: true

    before_save do |relationship|
      unless ['owner', 'shareholder'].include?(relationship.relate_type)
        relationship.hold_percent = nil
      end
    end
  end

  TARGET_OBJECT_KEYS     = %w(name number  region_code_is_null region_code_start_like)
  ASSOCIATED_COMPANY_KEYS= %w(name number region_code_is_null region_code_start_like)
  ASSOCIATED_PERSON_KEYS = %w(name number)
  RELATIONSHIP_KEYS      = %w(relate_type_in hold_percent desc)
  CLIENT_KEYS            = %w(user_id created_at_between company_id)

  module ClassMethods
    # search_relationships
    # search_attrs = {
    #   target_type: "company",
    #   target_object: {
    #     region_code: "331002"
    #   },
    #
    #   associated_type: "company",
    #   associated_object: {
    #     #name: "杭州商友全球网信息技术有限公司",
    #     #number: "..."
    #   },
    #
    #   relationship_attrs: { 
    #     #relate_type_in: ["owner","shareholder",...], 
    #     #hold_percent: 0.5
    #   },
    #
    #  client_attrs: {
    #     user_id: 2,
    #     created_at_between: ["2013-03-20","2013-03-20"]
    #   }
    # }
    #
    def search_attrs(opts ={})
      attrs = {
        #现在只有company_client
        target_type: "company",
        target_object: {},
        associated_type: "",
        associated_object: {},
        relationship_attrs: {},
        client_attrs: {}
      }.merge(opts.dup)

      [:target_object,:associated_object].each do |object|
        if attrs[object][:region_code].eql?("-1")
          attrs[object][:region_code_is_null] = true
        elsif attrs[object][:region_code] && attrs[object][:region_code] != "000000" 
          code = AreaCN::Code.new(attrs[object][:region_code])
          attrs[object][:region_code_start_like] = code.prefix
        end
        attrs[object].delete(:region_code)
      end

      if  !attrs[:client_attrs]["created_at_between"] && attrs[:client_attrs][:created_at_from]
        attrs[:client_attrs]["created_at_between"] = [
          attrs[:client_attrs].delete("created_at_from"),
          attrs[:client_attrs].delete("created_at_to")
        ]
      end
      attrs
    end


    def search_company_relationships(opts={})
      search_relationships(search_attrs(opts.symbolize_keys.merge(associated_type: "company")))
    end
    
    def search_person_relationships(opts={})
      search_relationships(search_attrs(opts.symbolize_keys.merge(associated_type: "person")))
    end

    #def validate_options(options,keys)
    #  options.assert_valid_keys(keys)
    #  keys.each do |key|
    #    unless options[key] 
    #      raise Skyeye::NoKeyProvided, "No #{key} provided for search relationships"
    #    end
    #  end
    #end

    def search_relationships(search_attrs)
      rc,ac =
        if search_attrs[:associated_type].eql?("company")
          [ClientCompanyRelationship,Company] 
        else
          [ClientPersonRelationship,Person]
        end

      tc,cc = 
        if search_attrs[:target_type].eql?("company")
          [Company,CompanyClient]
        else
          [Person,PersonClient]
        end

      join_client = "inner join #{cc.table_name} on #{rc.table_name}.client_type = '#{cc.name}' and #{cc.table_name}.id=#{rc.table_name}.client_id"
      join_target_object = "inner join #{tc.table_name} on #{tc.table_name}.id = #{cc.table_name}.#{tc.name.downcase}_id"

      alias_associated_object_table_name = "associated_object"
      join_associated__object = "inner join #{ac.table_name} #{alias_associated_object_table_name} on #{alias_associated_object_table_name}.id = #{rc.table_name}.#{ac.name.downcase}_id"

      target_object_where = gen_where(tc.table_name,search_attrs[:target_object].slice(*TARGET_OBJECT_KEYS))

      associated_object_where = 
      if ac == Company 
        gen_where(alias_associated_object_table_name,search_attrs[:associated_object].slice(*ASSOCIATED_COMPANY_KEYS))
      else
        gen_where(alias_associated_object_table_name,search_attrs[:associated_object].slice(*ASSOCIATED_PERSON_KEYS))
      end

      relationship_where = gen_where(rc.table_name,search_attrs[:relationship_attrs].slice(*RELATIONSHIP_KEYS))
      
      client_where = gen_where(cc.table_name,search_attrs[:client_attrs].slice(*CLIENT_KEYS))

      joins = [join_client]  
      unless target_object_where.blank? 
        joins << join_target_object
      end

      unless associated_object_where.blank? 
        joins << join_associated__object
      end
      rc.joins(joins).where(target_object_where).where(associated_object_where).where(relationship_where).where(client_where).order("client_id")
    end

    def gen_where(table_name,attrs)
      return [] if attrs.blank?
      where = attrs.inject([[],[]]) do |w,attr|
        next w if attr[1].blank? 
        if attr[0] =~ /(.*)_between/ 
          w[0] << ["#{table_name}.#{$1} BETWEEN ? AND ?"]
          begin_time = attr[1][0].beginning_of_day
          end_time = attr[1][1].end_of_day
          w[1] << begin_time.to_s(:db) << end_time.to_s(:db)
        elsif attr[0] =~ /(.*)_in/
          w[0] << ["#{table_name}.#{$1} in (?)"]
          w[1] << attr[1]
        elsif attr[0] =~ /(.*)_start_like/ 
          w[0] << ["#{table_name}.#{$1} LIKE ?"]
          w[1] << "#{attr[1]}%"
        elsif attr[0] =~ /(.*)_is_null/ 
          w[0] << ["#{table_name}.#{$1} is null"]
          w[1] << attr[1]
        else
          w[0] << ["#{table_name}.#{attr[0]} = ?"]
          w[1] << attr[1] 
        end
        w
      end
      return [] if where.first.blank? 
 
      [where[0].join(" AND "),*where[1]]
    end

  end

end
