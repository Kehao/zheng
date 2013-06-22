#encoding: utf-8
module SkyeyePower
  class ElecCompanyAccount < CompanyAccount
    attr_accessible :elec_number
    validates :elec_number,numericality: true,:presence => true
    belongs_to :company, class_name: SkyeyePower.company_class_name,counter_cache: true  

    def view_number
       if self.elec_number == SkyeyePower::CompanyAccount::UNCLASSIFIED_ACCOUNT_NUMBER.to_s
         "公司默认电账户"
       else
         self.elec_number
       end
    end

    def bill_desc
      "电费账户：#{elec_number}"
    end

    class << self
      def find_or_create_unclassified_account(company,author=nil)
        unclassified_account = company.elec_company_accounts
        .where(elec_number:CompanyAccount::UNCLASSIFIED_ACCOUNT_NUMBER)
        .first
        unless unclassified_account 
         unclassified_account = company.elec_company_accounts.create(
            elec_number:CompanyAccount::UNCLASSIFIED_ACCOUNT_NUMBER,
            author:author,
            description:"未归类电账单"
          )
        end
        unclassified_account
      end

      def resource_name
        :elec_company_accounts
      end
    end
  end
end
