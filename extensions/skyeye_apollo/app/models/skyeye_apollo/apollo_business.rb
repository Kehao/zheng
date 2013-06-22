module SkyeyeApollo
  class ApolloBusiness < ActiveRecord::Base
    include Enumerize
    attr_accessible :order_status, :black, :custinfoid

    belongs_to :company, :class_name => SkyeyeApollo.company_class_name 
    belongs_to :apollo_company, class_name: SkyeyeApollo::Apollo::Company.name, foreign_key: :custinfoid
    
    enumerize :order_status, :in => {loan_before: 0, loan_after: 1, closed: 2}

  end
end
