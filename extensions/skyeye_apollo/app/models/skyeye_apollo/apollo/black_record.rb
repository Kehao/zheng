module SkyeyeApollo
  module Apollo
    class BlackRecord < ActiveRecord::Base
      if Rails.env.production?
        establish_connection :apollo
        set_table_name "qqw_blacklist"
      end

      belongs_to :company, foreign_key: :custinfoid
    end
  end
end

# Apollo attributes
#   companyname
#   custinfoid

