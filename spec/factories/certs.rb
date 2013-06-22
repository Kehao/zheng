#encoding: utf-8
FactoryGirl.define do
  factory :cert do
    regist_id "330108000022757"
    orig_url "http://www.idinfo.cn/SignHandle?userID=3301080000025630"
    name "杭州义商全球网信息技术有限公司" 
    address "" 
    owner_name "方兴东" 
    regist_capital "1000万" 
    paid_in_capital "1000万" 
    company_type "有限责任公司（自然人"
    found_date "2008-07-15" 
    business_scope "技术开发、技术服务：计算机软件；服务：企业管理咨询；销售：工艺饰品，日用品\r\n" 
    business_start_date "2008-07-15" 
    business_end_date "2028-07-14" 
    regist_org "杭州市工商行政管理局高新区（滨江）分局" 
    approved_date "\r\n         2011 09 20\r\n         " 
    check_years "09,10,11" 
    company_id 1 
    created_at "2012-08-09 03:39:57" 
    updated_at "2012-08-09 03:40:05" 

    factory :qqw1 do
      regist_id "330782000019063"
      name  "义乌全球网实业有限公司"
      orig_url "http://www.idinfo.cn/SignHandle?userID=3307820002416378"
    end

  end
end

