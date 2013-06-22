module SkyeyeApollo
  module Apollo
    class Order < ActiveRecord::Base
      if Rails.env.production?
        establish_connection :apollo
        set_table_name "qqw_atzorder"
        set_primary_key :serialnum
      end

      belongs_to :company, foreign_key: :custinfoid
      has_one :order_detail, foreign_key: :appnum

      STATUS = {
        loan_before: %W(20 21 18 1 2 3 4 5 6 7 8 9410000 9420000 9410001 9410002 9410003 9410004 9410005 9410006 9410007 9410008 9410009 9410010 9420002 9510002 200201 200202 200203 200204 200205),
        loan_after:  %W(9510003 9420001),
        closed:      %W(9510005 9420003)
      }

      def status_name
        status = STATUS.detect { |name, codes| codes.include?(orderstatus) }
        status && status[0] || :loan_before
      end

      scope :loan_after, where(orderstatus: STATUS[:loan_after])

      def current_balance_amount
        order_detail.present? ? order_detail.loanbalance.to_i : 0
      end
    end
  end
end

# Apollo attributes
#   id
#   custinfoid
#   orderstatus
#   applydate
#   bizmanager
