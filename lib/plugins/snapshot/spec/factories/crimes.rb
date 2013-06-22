#encoding: utf-8
FactoryGirl.define do
  factory :crime do
    party_name "诸暨天马旅行社有限责任公司"
    party_number "798572939"
    case_id "(2009)绍诸民执字第03265号"
    case_state "已结"
    reg_date "2009-08-24"
    apply_money "20429.00"
    court_name "诸暨市人民法院"
    party_id nil
    party_type nil
    #orig_url 'http://www.zxaj.cn/search/index.php?act=detail&param=a%3A8%3A%7Bs%3A8%3A%22party_id%22%3Bs%3A8%3A%2235132975%22%3Bs%3A10%3A%22party_name%22%3Bs%3A26%3A%22%D6%EE%F4%DF%CC%EC%C2%ED%C2%C3%D0%D0%C9%E7%D3%D0%CF%DE%D4%F0%C8%CE%B9%AB%CB%BE%22%3Bs%3A11%3A%22card_number%22%3Bs%3A9%3A%22798572939%22%3Bs%3A7%3A%22case_id%22%3Bs%3A25%3A%22%282011%29%C9%DC%D6%EE%D6%B4%C3%F1%D7%D6%B5%DA05678%BA%C5%22%3Bs%3A8%3A%22reg_date%22%3Bs%3A10%3A%222011-11-16%22%3Bs%3A10%3A%22case_state%22%3Bs%3A4%3A%22%D2%D1%BD%E1%22%3Bs%3A11%3A%22apply_money%22%3Bs%3A7%3A%227520.00%22%3Bs%3A10%3A%22court_name%22%3Bs%3A14%3A%22%D6%EE%F4%DF%CA%D0%C8%CB%C3%F1%B7%A8%D4%BA%22%3B%7D&type=public&PartyName=%D6%EE%F4%DF%CC%EC%C2%ED%C2%C3%D0%D0%C9%E7%D3%D0%CF%DE%D4%F0%C8%CE%B9%AB%CB%BE&CardNumber='
    orig_url 'http://www.zxaj.cn/search/index.php?act=detail&param=a%3A8%3A%7Bs%3A8%3A%22party_id%22%3Bs%3A8%3A%2232341612%22%3Bs%3A10%3A%22party_name%22%3Bs%3A26%3A%22%D6%EE%F4%DF%CC%EC%C2%ED%C2%C3%D0%D0%C9%E7%D3%D0%CF%DE%D4%F0%C8%CE%B9%AB%CB%BE%22%3Bs%3A11%3A%22card_number%22%3Bs%3A9%3A%22798572939%22%3Bs%3A7%3A%22case_id%22%3Bs%3A25%3A%22%282009%29%C9%DC%D6%EE%C3%F1%D6%B4%D7%D6%B5%DA03265%BA%C5%22%3Bs%3A8%3A%22reg_date%22%3Bs%3A10%3A%222009-08-24%22%3Bs%3A10%3A%22case_state%22%3Bs%3A4%3A%22%D2%D1%BD%E1%22%3Bs%3A11%3A%22apply_money%22%3Bs%3A8%3A%2220429.00%22%3Bs%3A10%3A%22court_name%22%3Bs%3A14%3A%22%D6%EE%F4%DF%CA%D0%C8%CB%C3%F1%B7%A8%D4%BA%22%3B%7D&type=public&PartyName=%D6%EE%F4%DF%CC%EC%C2%ED%C2%C3%D0%D0%C9%E7%D3%D0%CF%DE%D4%F0%C8%CE%B9%AB%CB%BE&CardNumber='
    snapshot_path nil

#FactoryGirl.define do
#  factory :crime do
#    sequence(:party_number) { |n| "#{n + 1}".rjust(7, '3')}
#    sequence(:case_id) { |n| "#{n + 1}".rjust(10, '3')}
#    sequence(:card_number) { |n| "#{n + 1}".rjust(6, '3')}
#
#    party_name     '全球网'
#    case_state     'case_state'
#    reg_date       'reg_date: done'
#    apply_money    '10w'
#    court_name     'court_name'
#    orig_url       'orig_url'
  end
end
