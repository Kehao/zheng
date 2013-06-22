#encoding: utf-8
module KeyValues
  class Base < ActiveHash::Base
   # def self.options
   #   all.map {|t| [t.name, t.code]}
   # end

   # # {code1: name1, code2: name2}
   # def self.hash
   #   Hash[*(all.map{|t| [t.code, t.name]}.flatten)]
   # end

   # def self.find_by_code(code)
   #   super(code.to_s)
   # end
  end

  ## initialize the default role and admin account
  class Institution < Base
    self.data = [
        {:id=>1, :name=>"建设银行",    :short_name=>"建设银行"},
        {:id=>2, :name=>"全球网",      :short_name=>"QQW"},
        {:id=>3, :name=>"浦发银行",    :short_name=>"浦发银行"},
        {:id=>4, :name=>"工商银行",    :short_name=>"工商银行"},
        {:id=>5, :name=>"中信银行",    :short_name=>"中信银行"},
        {:id=>6, :name=>"恒丰银行",    :short_name=>"恒丰银行"},
        {:id=>7, :name=>"台州银行",    :short_name=>"台州银行"},
        {:id=>8, :name=>"民生银行",    :short_name=>"民生银行"},
        {:id=>9, :name=>"南洋商业银行", :short_name=>"南洋商业银行"},
        {:id=>10,:name=>"广发银行",    :short_name=>"广发银行"},
        {:id=>11,:name=>"杭州联合银行", :short_name=>"杭州联合银行"},
        {:id=>12,:name=>"北京银行",    :short_name=>"北京银行"},
        {:id=>13,:name=>"中安信业",    :short_name=>"中安信业"},
        {:id=>14,:name=>"星展银行",    :short_name=>"星展银行"},
        {:id=>15,:name=>"中国银行",    :short_name=>"中国银行"}
    ]
  end

  class Industry < Base
    self.data = [
      {:id=>100,:name=>"农林牧渔业"},
      {:id=>101,:name=>"采矿业"},
      {:id=>102,:name=>"制造业"},
      {:id=>103,:name=>"电力、燃气及水的生产和供应业"},
      {:id=>104,:name=>"建筑业"},
      {:id=>105,:name=>"交通运输、仓储和邮政业"},
      {:id=>106,:name=>"信息传输、计算机服务和软件业"},
      {:id=>107,:name=>"批发和零售业"},
      {:id=>108,:name=>"住宿和餐饮业"},
      {:id=>109,:name=>"金融业"},
      {:id=>110,:name=>"房地产业"},
      {:id=>111,:name=>"租赁和商务服务业"},
      {:id=>112,:name=>"科学研究、技术服务和地质勘查业"},
      {:id=>113,:name=>"水利、环境和公共设施管理业"},
      {:id=>114,:name=>"居民服务和其他服务业"},
      {:id=>115,:name=>"教育"},
      {:id=>116,:name=>"卫生、社会保障和社会福利业"},
      {:id=>117,:name=>"文化、体育和娱乐业"},
      {:id=>118,:name=>"公共管理和社会组织"},
      {:id=>119,:name=>"其它"}
    ] 
  end

  class Role < Base
    include ActiveHash::Associations
    has_one :ability, class_name: 'KeyValues::Ability'

    self.data = [
      {:id => 100000, :name => "admin",      :title => "系统管理员",     :description =>  "系统的拥有者,具有最高权限"},
      {:id => 100001, :name => "member",     :title => "客户经理",       :description =>  "负责日常管理客户"},
      {:id => 100002, :name => "cs_manager", :title => "客服经理",       :description =>  "负责日常管理客服"},
      {:id => 100003, :name => "cs",         :title => "客服",           :description =>  "为客户经理服务"},
      {:id => 100004, :name => "cs_supporter",:title => "用户信息提供者", :description =>  "为系统供应水电号等信息"}
    ]
  end

  class Ability < Base
    include ActiveHash::Associations
    belongs_to :role, class_name: 'KeyValues::Role'
    
    self.data = [
      {:id=>100000, :role_id=>100000, :can=>::Role.role_hash},
      {:id=>100001, :role_id=>100001, :can=>::Role.role_hash},
      {:id=>100002, :role_id=>100002, :can=>::Role.role_hash},
      {:id=>100003, :role_id=>100003, :can=>::Role.role_hash},
      {:id=>100004, :role_id=>100004, :can=>::Role.role_hash}
    ]
  end
end
