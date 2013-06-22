#encoding: utf-8
module SkyeyePower
  module Admin
    class ElecCompanyAccountsController < CompanyAccountsController
      expose(:resources) { SkyeyePower::ElecCompanyAccount.resource_name }
    end
  end
end
