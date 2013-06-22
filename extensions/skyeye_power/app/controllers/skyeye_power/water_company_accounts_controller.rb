#encoding: utf-8
module SkyeyePower
    class WaterCompanyAccountsController < CompanyAccountsController
      expose(:resources) { SkyeyePower::WaterCompanyAccount.resource_name }
    end
end
