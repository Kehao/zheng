module SkyeyePower
  class Bill < ActiveRecord::Base
    attr_accessible :amount, :cost, :last_number, :paid, :record_time, :this_number,:number,:category

    validates :cost, presence: true
    validates :cost,numericality: true
    validates :record_time,presence: true
    validates :amount,presence: true

    belongs_to :company, class_name: SkyeyePower.company_class_name

    belongs_to :company_account 

    Category = {
      water: 1, 
      electricity: 2
    }

    scope :water,       where(category: Category[:water]) 
    scope :electricity, where(category: Category[:electricity])
  end
end
