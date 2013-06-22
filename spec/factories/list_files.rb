# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :list_file do
    name          "300yuqing.xls" 
    clients_list  { File.open(File.join(Rails.root, "spec/files/300yuqing.xls")) }
  end
end
