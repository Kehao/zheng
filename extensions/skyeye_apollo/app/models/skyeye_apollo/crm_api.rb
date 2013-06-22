#encoding: utf-8
require 'httparty'
module SkyeyeApollo
  module CrmApi
    extend self
    TIMEOUT = 60
    # CRM_URL = "http://192.168.1.140:4444/crm/dealSkyEyeRiskWarn.action"
    CRM_URL = "http://192.168.2.187:8080/Apollocrm/dealSkyEyeRiskWarn.action"

    WarnType   = 'WI0000075'
    WarnLevel  = '1'
    WarnOrigin = '1'
    Key        = ''

    def zou_ni(content, custinfoid, options = {})
      response = HTTParty.post(CRM_URL, send_params(content, custinfoid, options))
    end

    def send_params(content, custinfoid, options = {})
      opts = options.dup
      opts.reverse_merge(key: Key, warnorigin: WarnOrigin, warnlist: warnlist(content, custinfoid, options))
    end

    def warnlist(content, custinfoid, options = {})
      opts = options.dup
      opts.reverse_merge(customerid: custinfoid, warntype: WarnType, warnlevel: WarnLevel, warndetail: content)
    end

  end
end