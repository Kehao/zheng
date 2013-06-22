module SkyeyeApollo
  class Engine < ::Rails::Engine
    isolate_namespace SkyeyeApollo

    engine_name "skyeye_apollo"

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :rspec
    end

    initializer "init class names" do
      SkyeyeApollo.user_class_name    = "User"
      SkyeyeApollo.company_class_name = "Company"
    end

    config.to_prepare do
      if SkyeyeApollo.company_class
        SkyeyeApollo.company_class.class_eval do
          # Add apollo create way
          self::CREATE_WAY[:apollo] = 2  # CREATE_WAY[:apollo] = CREATE_WAY.length - 1 

          has_one :apollo_business, :class_name => "SkyeyeApollo::ApolloBusiness", :dependent => :destroy
          scope :from_apollo, where(create_way: self::CREATE_WAY[:apollo])
          scope :loan_after,  includes(:apollo_business).where("skyeye_apollo_apollo_businesses.order_status = 1")
          
          def apollo_black?
            apollo_business.try(:blank)
          end
        end
      end
    end

    config.after_initialize do
      Skyeye::Plugin.register do |plugin|
        plugin.name       = "skyeye_apollo"
        plugin.scope      = [:company, :company_client]
        plugin.version    = SkyeyePower::VERSION
        plugin.mount_path = nil 
        plugin.cell       = "skyeye_apollo/menu"
        
        # Permissions scoped in skyeye_power
        #
        # So in user.cando it will be skyeye_power__[resource_name] like skyeye_power__bill.
        plugin.access_control do
        end

        plugin.permissions_access = {
          default: {
          }
        }

        plugin.cancan do |user|
        end
      end
    end
  end
end
