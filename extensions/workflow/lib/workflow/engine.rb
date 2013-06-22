require File.expand_path('../trackable_additions', __FILE__)
module Workflow
  class Engine < ::Rails::Engine
    isolate_namespace Workflow

    engine_name "workflow"

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :rspec
    end

    initializer "init class names" do
      Workflow.user_class_name = "User"
      Workflow.role_class_name = "Role"
      Workflow.company_account_class_name = "SkyeyePower::CompanyAccount"
    end

    config.to_prepare do
      if Workflow.role_class
        Workflow.role_class.has_many :workflows, class_name: "Workflow::Workflow",dependent: :destroy
      end
      if Workflow.company_account_class
        Workflow.company_account_class.has_one :trace,class_name: "Workflow::Trace",as: :trackable,dependent: :destroy
        Workflow.company_account_class.attr_accessible :trace
        Workflow.company_account_class.send :include,::Workflow::TrackableAdditions
      end
    end

    config.after_initialize do
      Skyeye::Plugin.register do |plugin|
        plugin.name       = "workflow"
        plugin.scope      = [:system]
        plugin.version    = ::Workflow::VERSION
        plugin.mount_path = "/workflow"
        plugin.cell       = "workflow/menu"

        plugin.cancan do |user|
        end
      end
    end


  end
end
