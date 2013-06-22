#encoding: utf-8
namespace :system do
  desc "system init"
  task :init  do
    require File.expand_path('../../../config/environment', __FILE__)
    Skyeye.safe_call :init
  end

  ##=> rake system:call:reset_company_power_account_count  
  # => 初始化公司水电账户数
  namespace :call do

    task :init_industry => [:environment] do
      Skyeye.safe_call :init_industry
    end

    task :reset_company_power_account_count do
      require File.expand_path('../config/environment', __FILE__)
      Skyeye.safe_call :reset_company_power_account_count
    end
  end

  desc "向apollo发送当天告警"
  task :report_alarm_today => [:environment] do
    Reporter::Apollo.report_today
  end

  desc "向apollo发送全部没有发送(当天除外)的告警"
  task :report_alarm_all_except_today => [:environment] do
    Reporter::Apollo.report_all_except_today
  end
  
  desc "向apollo发送全部没有发送的告警"
  task :report_alarm_all => [:environment] do
    Reporter::Apollo.report_all
  end

end

namespace :snapshot do
  desc "start fetching snapshot ..."
  task :start => [:environment]   do
    begin
      SnapshotWorker.perform_async
      puts "SnapshotWorker scheduled !!!"
    rescue  Exception => e
      Rails.logger.error "error when enqueue worker; error_message:" + e.message
    end
  end

end

namespace :spider do
  namespace :waiting do
    desc "重新安排状态为等待的spider加入到sidekiq队列, 爬取内容"
    task :run => [:environment] do
      Spider.reschedule_waiting_to_run
    end
  end

  namespace :company do
    namespace :waiting do
      desc "重新安排状态为等待的公司spider加入到sidekiq队列, 爬取内容"
      task :run => [:environment] do
        Spider.reschedule_company_waiting_to_run
      end
    end

    desc "安排所有的公司spider加入到sidekiq队列，爬取内容"
    task :run => [:environment] do
      CompanySpider.schedule_all_to_run
    end

  end

end

namespace :company do
  namespace :problem do
    desc "导出有问题的企业"
    task :export => [:environment]do
      Company.export_problem
    end
  end
end

namespace :user do
  namespace :company_clients do
    namespace :problem do
      desc "导出某个用户有问题的企业客户案件"
      task :export, [:user_name] => [:environment] do |t, args|
        user_name = args[:user_name]
        if user_name.blank?
          puts("Please specify a user name like `rake user:company_clients:problem:export[foo]` ")  
          exit(1)
        end

        unless user = User.where(name: user_name).first
          puts("User not exist!")
          exit(1)
        end

        user.export_problem_companies
      end
    end
  end
end

# 对公司(用户的客户)法院预警的检测
# namespace :company_clients do
#   task :court_alarm => [:envorinment] do
#     CompanyClient.uniq.select([:id, :company_id]).find_in_batches do |company_clients|
#       Company.where(id: company_clients.map(&:company_id)).each do |company|
#         alarmed_crime_ids = company.court_alarms.map(&:crime_ids).flatten.uniq
#         new_crime_ids = company.crime_ids - alarmed_crime_ids
#         if new_crime_ids.present?
#           CourtAlarm.create(:subject => company, :carriage => {:crime_ids => new_crime_ids})
#         end
#       end
#     end
#   end
# end

namespace :data do
  desc "整理数据，主要是crime和company之间由于抓取存储的bug导致不对应" 
  task :clean => [:environment] do
    Company.find_each do |company|
      removed_crimes = company.crimes.select { |crime| crime.party_name.strip != company.name.strip }
      removed_crimes.each(&:destroy)
    end
  end

  desc "整理数据，clean those old crime but skied new in system." 
  task :clean_crimes => [:environment] do
    Company.find_each do |company|
      cm = company.all_crimes
      cm.each do |cr|
        rest = cm - [cr]
        dups = rest.find_all{|crime| crime.case_id == cr.case_id && crime.created_at < cr.created_at}
        dups.each(&:destroy)
      end
    end
  end

  desc "初始化company的court alarm"
  task :init_company_court_alarm => [:environment] do
    Company.find_each do |company|
      alarm_court = company.alarm_court
      #if alarm_court
      #  alarm_court.sent_recipient_ids.push(*company.user_ids)
      #  alarm_court.sent_recipient_ids.uniq!
      #  alarm_court.save!
      #end
    end
  end



  desc "每一次更新需要的数据迁移任务"
  task :migrate => [:environment] do
    migrate_crimes
    update_crimeable_court_status
  end

  # Migrate from company_crimes and person_crimes table 
  def migrate_crimes
    # Create anonymous class to access data, 
    # because of company and person crimes have been new associations defined

    puts "migrate crimes..."

    company_crime_model = Class.new(ActiveRecord::Base)
    company_crime_model.table_name = 'company_crimes'

    company_crime_model.find_each do |company_crime|
      crime = Crime.find(company_crime.crime_id)

      crime.party_id = company_crime.company_id
      crime.party_type = 'Company'
      crime.save
    end

    person_crime_model  = Class.new(ActiveRecord::Base)
    person_crime_model.table_name = 'person_crimes'

    person_crime_model.find_each do |person_crime|
      crime = Crime.find(person_crime.crime_id)

      crime.party_id = person_crime.person_id
      crime.party_type = 'Person'
      crime.save
    end

    puts "migrate crimes completed."
  end

  def update_crimeable_court_status
    puts "update Company and Person court_status where court_status is NULL"

    Company.update_all({:court_status => Company.court_status.ok.value}, {:court_status => nil})
    Person.update_all({:court_status => Person.court_status.ok.value}, {:court_status => nil})

    puts "update court_status complete."
  end
end
