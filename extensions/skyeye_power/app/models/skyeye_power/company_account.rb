module SkyeyePower
  class CompanyAccount < ActiveRecord::Base
    attr_accessible :description, :type, :author
    belongs_to :author, :class_name => SkyeyePower.user_class_name, :foreign_key => "author_id"
    has_many :bills

    UNCLASSIFIED_ACCOUNT_NUMBER = 999999

    def chart_data   
      bills.order("record_time DESC").limit(6).map do |bill|
        { record_time: bill.record_time.strftime("%Y-%m"), cost: bill.cost }
      end
    end

    class << self
      def subclasses
        [SkyeyePower::WaterCompanyAccount, SkyeyePower::ElecCompanyAccount]
      end

      def resource_names
        subclasses.collect &:resource_name
      end
    end
  end
end
