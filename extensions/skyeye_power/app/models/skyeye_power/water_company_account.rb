#encoding: utf-8
module SkyeyePower
  class WaterCompanyAccount < CompanyAccount    
    attr_accessible :water_number
    validates :water_number,numericality: true,:presence => true 
    belongs_to :company, class_name: SkyeyePower.company_class_name,counter_cache: true  

    def bill_desc
      "水费账户：#{water_number}"
    end

    def view_number
      if self.water_number == SkyeyePower::CompanyAccount::UNCLASSIFIED_ACCOUNT_NUMBER.to_s
        "公司默认水账户"
      else
        self.water_number
      end
    end


    class << self
      def find_or_create_unclassified_account(company,author=nil)
        unclassified_account = company.water_company_accounts
        .where(water_number:CompanyAccount::UNCLASSIFIED_ACCOUNT_NUMBER).first

        unless unclassified_account 
          unclassified_account = company.water_company_accounts.create(
            water_number:CompanyAccount::UNCLASSIFIED_ACCOUNT_NUMBER,
            author:author,
            description:"未归类水账单"
          )
        end
        unclassified_account
      end

      def resource_name
        :water_company_accounts
      end
    end
  end
end
