module SkyeyeApollo
  module Apollo
    class OrderDetail < ActiveRecord::Base
      if Rails.env.production?
        establish_connection :apollo
        set_table_name "QQW_ATZBANKLOAN"
      end

      belongs_to :company, foreign_key: :custinfoid
      belongs_to :order, foreign_key: :appnum
    end
  end
end

# Apollo attributes
#   id
#   custinfoid
#   orderstatus
#   applydate
#   bizmanager
