# encoding:utf-8
FactoryGirl.define do
factory "Workflow::Status" do
  factory :status1 do
    name "已提供水号"
    is_closed false
    is_default true 
    html_color "FFFFFF"
    description "有提供水电号权限的用户提供水电号"
    position nil
  end

  factory :status2 do
    name "开始编辑"
    is_closed false
    is_default false
    html_color "FFFFFF"
    description "相关工作人员查询水电信息"
    position nil
  end

  factory :status3 do
    name "已编辑完成,等待审核"
    is_closed false
    is_default false
    html_color "FFFFFF"
    description "等待审核"
    position nil
  end

  factory :status4 do
    name "已审核"
    is_closed false
    is_default false
    html_color "FFFFFF"
    description "审核完成"
    position nil
  end

  factory :status5 do
    name "发回重新编辑"
    is_closed false
    is_default false
    html_color "FFFFFF"
    description "审核不能过,发回重新编辑"
    position nil
  end

end
end
