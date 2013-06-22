# encoding:utf-8
FactoryGirl.define do

  factory :role do
    factory :r_admin do
      id   10000
      name "admin"
      description "系统的拥有者,具有最高权限"
      title "系统管理员"
    end

    factory :r_member do
      id   10001
      name "member"
      description "负责日常管理客户"
      title "客户经理"
    end

    factory :r_cs_manager do
      id   10002
      name "cs_manager"
      description "负责日常管理客服"
      title "客服经理"
    end

    factory :r_cs do
      id   10003
      name "cs"
      description "为客户经理服务"
      title "客服"
    end

    factory :r_cs_supporter do
      id   10004
      name "cs_supporter"
      description "为系统供应水电号等信息"
      title "用户信息提供者"
    end

  end

end
