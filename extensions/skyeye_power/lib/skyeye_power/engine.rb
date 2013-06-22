module SkyeyePower
  class Engine < ::Rails::Engine
    isolate_namespace SkyeyePower


    config.to_prepare do
      SkyeyePower.user_class_name    = "User"
      SkyeyePower.company_class_name = "Company"
      SkyeyePower.company_class.has_many :bills, class_name: "SkyeyePower::Bill", dependent: :destroy
      SkyeyePower.company_class.has_many :water_company_accounts, class_name: "SkyeyePower::WaterCompanyAccount",dependent: :destroy
      SkyeyePower.company_class.has_many :elec_company_accounts,  class_name: "SkyeyePower::ElecCompanyAccount",dependent: :destroy
    end

    config.after_initialize do
      Skyeye::Plugin.register do |plugin|
        plugin.version    = SkyeyePower::VERSION
        plugin.name       = "skyeye_power"
        plugin.mount_path = "/skyeye_power"
        plugin.cell       = "skyeye_power/menu"

        #plugin.scope      = [:company, :company_client]
        
        # Permissions scoped in skyeye_power
        #
        # So in user.cando it will be skyeye_power__[resource_name] like skyeye_power__bill.
        plugin.access_control do
          permission :water_company_account, [:create, :read, :update, :destroy]
          permission :elec_company_account,  [:create, :read, :update, :destroy]
          permission :bill,                  [:create, :read, :update, :destroy]
        end

        plugin.permissions_access = { default: { bill: {read: true} } }

        plugin.cancan do |user|
          if user.guest?
            cannot :manage, SkyeyePower::Bill 
            cannot :manage, SkyeyePower::WaterCompanyAccount 
            cannot :manage, SkyeyePower::ElecCompanyAccount 

          elsif user.role?(:cs_manager)
            can :manage, SkyeyePower::Bill 
            can :manage, SkyeyePower::WaterCompanyAccount 
            can :manage, SkyeyePower::ElecCompanyAccount

          elsif user.role?(:cs)
            can :manage, SkyeyePower::Bill 
            #can :read,   SkyeyePower::Bill if user.cando.skyeye_power__bill.read

          elsif user.role?(:cs_supporter)

          elsif user.member? && user.cando
            can :read, SkyeyePower::Bill if user.cando.skyeye_power__bill.read
          end

        end
      end
    end
  end
end

# config.generators do |g|
#   g.orm             :active_record
#   g.template_engine :haml
#   g.test_framework  :rspec
# end

