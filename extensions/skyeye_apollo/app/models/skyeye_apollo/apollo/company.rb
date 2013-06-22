module SkyeyeApollo
  module Apollo
    class Company < ActiveRecord::Base
      if Rails.env.production?
        establish_connection :apollo
        set_table_name "qqw_atzentbase"
        set_primary_key :custinfoid
        set_datetime_columns :createtime
        default_scope order(:createtime)
      end

      has_many :orders,          foreign_key: :custinfoid
      has_many :order_details,   foreign_key: :custinfoid
      has_one  :black_record,    foreign_key: :custinfoid  
      has_one  :apollo_business, foreign_key: :custinfoid 

      class << self
        def sync_user
          # @sync_user ||= SkyeyeApollo.user_class.where(name: "shenchao").first || SkyeyeApollo.user_class.create(name: "shenchao", password: "123456", email: "shenchao@qqw.com.cn")
          @sync_user = ::UserPlugin.where(:plugin_name => "skyeye_apollo").first.user
        end

        def sync_users
          @sync_users = ::User.joins(:plugins).where(:user_plugins => {:plugin_name => "skyeye_apollo"})
        end

        def sync
          self.includes(:orders, :black_record).find_each do |apollo_company|
            puts "#{Time.now.in_time_zone}: sync #{apollo_company.companyname}..."
            apollo_company.sync
            puts "#{Time.now.in_time_zone}: sync #{apollo_company.companyname} complete."
          end
          remove_not_loan_after_companies
        end
        alias_method :sync_all, :sync

        def remove_not_loan_after_companies
          sync_user.companies.includes(:apollo_business).where("skyeye_apollo_apollo_businesses.order_status != 1").each do |company|
            puts "removing #{company.name}."
            sync_user.company_clients.find_by_company_id(company.id).delete
          end
        end
      end

      def sync_user
        self.class.sync_user
      end

      def sync_users
        self.class.sync_users
      end

      def attributes_to_skyeye
        {
          company:  {
            name: companyname, 
            number: licensecode, 
            code: orgcode, 
            region_code: regioncode
          }, 
          apollo_business: {
            order_status: to_skyeye_apollo_business_order_status,
            black: !!black_record,
            custinfoid: id
          },
          person:   {name: legalrep, number: idcard},
          industry: {name: ym_industry}
        }
      end

      def to_skyeye_apollo_business_order_status
        order_status_names = self.orders.map(&:status_name).uniq

        return :loan_after if order_status_names.include?(:loan_after)
        return :closed if order_status_names == [:closed]

        :loan_before
      end

      def sync 
        attrs = self.attributes_to_skyeye

        # find industry or create industry
        industry = Industry.where(attrs[:industry]).first_or_create

        # find person or create person
        person = Person.where(attrs[:person]).first_or_create

        # find company update or create company
        company = ::Company.where(attrs[:company].dup.extract!(:name)).first_or_initialize
        company.create_way  = ::Company::CREATE_WAY[:apollo]
        company.number      = attrs[:company][:number]        if attrs[:company][:number].present?
        company.code        = attrs[:company][:code]          if attrs[:company][:code].present?
        company.region_code = attrs[:company][:region_code]   if attrs[:company][:region_code].present?

        company.save

        unless company.new_record?
          # 更新或创建apollo系统的业务属性 
          if company.apollo_business
            company.apollo_business.update_attributes(attrs[:apollo_business])
          else
            company.create_apollo_business(attrs[:apollo_business])
          end

          # associate company, person, industry and sync_user
          if !industry.new_record? and company.industry_name != industry.name
            company.industry = industry
            company.save
          end

          if !person.new_record? && company.owner.blank?
            company.owner = person
            company.save
          end

          sync_users.each do |user| 
            user.add_company(company) if company.apollo_business.try(:order_status) == "loan_after"
          end
        end
      end
    end
  end
end

# == Apollo attributes
#     companyname  => 公司名
#     legalrep     => 法人名
#     idcard       => 法人身份证
#     licensecode  => 公司注册号
#     orgcode      => 组织机构代码
#     createtime
#     ym_industry  => 行业
#     regioncode   => 区代码
#     city         => 城市
#     regon        => 区县
