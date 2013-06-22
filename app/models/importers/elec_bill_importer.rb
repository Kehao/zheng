#encoding: utf-8
class ElecBillImporter < PowerBillImporter
  def faye_go_to_path
    "/skyeye_power?tab=elec_bill_importer#power-importers"
  end
  def account_class
    SkyeyePower::ElecCompanyAccount
  end
end
