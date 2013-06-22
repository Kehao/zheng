#encoding: utf-8
module SkyeyePower
  module ApplicationHelper

    def resources_nav
      content_tag :ul,:class=>"nav nav-tabs" do
        CompanyAccount.resource_names.each do |name|
          li_class = (resources == name ? "active" : "")
          title=t("skyeye_power/" + name.to_s.singularize,:scope=>[:activerecord,:models])
          concat (content_tag :li,(link_to title,[:admin,company,name]),:class => li_class)
        end
      end
    end

    def client_resources_nav
      content_tag :ul,:class=>"nav nav-tabs" do
        CompanyAccount.resource_names.each do |name|
          li_class = (resources == name ? "active" : "")
          title=t("skyeye_power/" + name.to_s.singularize,:scope=>[:activerecord,:models])
          concat (content_tag :li,(link_to title,[company,name]),:class => li_class)
        end
      end
    end
  end
end
