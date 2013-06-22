# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#set :rails_root,File.expand_path('../../', __FILE__)
#set :output, "#{rails_root}/log/cron.log"
#set :environment, "development"
#env :PATH, ENV['PATH']
#every 1.minutes  do
#  command 'source /home/qiu/.rvm/scripts/rvm;cd /home/qiu/w/skyeye && rvm ruby-1.9.3-p0 && gem install bundler && RAILS_ENV=development bundle exec rake snapshot:start --silent >> /home/qiu/w/skyeye/log/cron.log 2>&1'
#  #rake "snapshot:start"
#  puts "snapshot started..."

rails_root = File.expand_path('../../', __FILE__)
set :output, File.join(rails_root, "log/cron.log")
set :environment, "production"
set :path, rails_root

# Load plugins schedule file
Dir.glob(File.expand_path("../../extensions/*/config/schedule.rb", __FILE__)).each do |schedule_file|
  instance_eval(File.read(schedule_file))
end

# 每月通过爬虫抓取更新公司信息(法院，工商等)
# every :month, :at => '02:30 am' do
#   runner "CompanySpider.schedule_all_to_run"
# end

# 每天通过爬虫抓取更新已经成为客户的公司信息(法院，工商等)
every 5.days, :at => "00:00 am" do
  runner "CompanyClient.sync_only_court_data_of_all_companies"
end

# 每次爬取完以后生成预警信息 
every 5.days, :at => "05:00 am" do
  runner "CompanyClient.alarm_court_all"
end

every 1.day, :at => "11:00 am" do
  runner "Reporter::Apollo.report_today"
end

# 每天把发布的通知(法院预警)发送给用户
every 5.day, :at => "07:00 am" do
  runner "Notice.notify_all"
end

# 每天清理在等待状态的spider去重新抓取
every 1.day, :at => '1:00 am' do
  runner "Spider.reschedule_waiting_to_run"
end

every 1.day, :at => "03:20 am" do
  command "mysqldump -u root -p123qqw.com skyeye_production > /home/ruby/data_backup/skyeye_production-#{Date.today}.sql"
end
