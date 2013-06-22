#encoding: utf-8
class WaterBillImporter < PowerBillImporter

  def faye_go_to_path
    "/skyeye_power#power-importers"
  end

  def account_class
    SkyeyePower::WaterCompanyAccount
  end
end
