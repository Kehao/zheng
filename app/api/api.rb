#encoding: utf-8
require "api_companies"
require 'grape-swagger'
module API 
  class Root < Grape::API
    format :json
    prefix "api"
    version "v1"

    mount API::Companies 

    add_swagger_documentation(
      :api_version => "v1",
      #:base_path => "http://localhost:3000/api/v1",
      :markdown => true,
      :mount_path => "resources"
    )

  end
end
