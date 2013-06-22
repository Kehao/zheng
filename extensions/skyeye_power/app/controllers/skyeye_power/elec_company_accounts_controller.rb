#encoding: utf-8
module SkyeyePower
    class ElecCompanyAccountsController < CompanyAccountsController
      expose(:resources) { SkyeyePower::ElecCompanyAccount.resource_name }
    end
end
