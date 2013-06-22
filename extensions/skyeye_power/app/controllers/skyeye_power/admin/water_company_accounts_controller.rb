#encoding: utf-8
module SkyeyePower
  module Admin
    class WaterCompanyAccountsController < CompanyAccountsController
      expose(:resources) { SkyeyePower::WaterCompanyAccount.resource_name }
    end
  end
end
