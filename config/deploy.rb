#encoding: utf-8
# default_environment["LC_CTYPE"] = "zh_CN.UTF-8"
default_environment["NLS_LANG"] = 'AMERICAN_AMERICA.UTF8'
# set  :rails_env,       :development

# ==================================
# Override default cap recipe
# set :shared_children,   %w(public/system public/uploads log tmp/pids)
shared_children.concat %w(public/uploads public/certs public/crimes public/system exports) # symlink to shared
# ==================================

set  :application,     "skyeye"
set  :repository,      "git@58.215.177.236:skyeye.git" 
# set  :branch,          "plugin"
set  :scm,             :git
set  :user,            "ruby"
set  :deploy_to,       "/home/#{user}/applications/#{application}"
set  :runner,          "ruby"
set  :use_sudo,        false
set  :deploy_via,      :remote_cache  # remote_cache/checkout 
set  :unicorn_file,    "#{fetch(:current_path)}/config/unicorn.rb"
set  :keep_releases,   5

set  :sidekiq_role,    :backend
set  :whenever_roles,  :backend

role :web,             "115.238.73.25", port: 5122
role :app,             "115.238.73.25", port: 5122 
role :db,              "115.238.73.25", port: 5122, primary: true

role :backend,         "115.238.73.25", port: 5222

default_run_options[:pty] = true # 伪终端

#=================================
# before or after hooks 
#=================================
after "deploy:finalize_update", "deploy:link_database_yml"
after "deploy:restart", "deploy:cleanup"

require "bundler/capistrano"  # bundle install to current_path/shared/bundle
require 'sidekiq/capistrano'  # app重启后，自动重启sidekiq

# ============= rvm capistrano ===========
# Load RVM's capistrano plugin.    
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

# ============ whenever capistrano ===========
set :whenever_environment, defer { fetch :rails_env, "production" }
set :whenever_identifier,  defer { "#{application}_#{rails_env}" }
set :whenever_command,     "bundle exec whenever"
require 'whenever/capistrano'

#=================================
# Task define
#=================================
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app, :except => {:no_release => true} do
    unicorn.start
  end

  desc "Stop Application"
  task :stop, :roles => :app, :except => {:no_release => true} do
    unicorn.stop
  end

  desc "Restart Application"
  task :restart, :roles => :app, :except => {:no_release => true} do
    unicorn.restart
  end

  desc "Link config/database.yml to config/database.yml.example"
  task :link_database_yml do
    on_rollback do
      run "rm #{latest_release}/config/database.yml"
    end
    run "ln -sf #{latest_release}/config/database.yml.example #{latest_release}/config/database.yml"
  end
end

namespace :unicorn do
  task :start, :roles => :app, :except => {:no_release => true} do
    run <<-START
      cd #{fetch(:current_path)} && 
      bundle exec unicorn_rails -c #{unicorn_file} -E #{rails_env} -D
    START
  end

  task :stop, :roles => :app, :except => {:no_release => true} do
    # graceful shutdown
    run <<-STOP
      kill -QUIT `cat #{fetch(:current_path)}/tmp/pids/unicorn.pid` 
    STOP
  end

  task :restart, :roles => :app, :except => {:no_release => true} do
    # USR2 reexecute the running binary.
    # run <<-RESTART
    #   kill -USR2 `cat #{fetch(:current_path)}/tmp/pids/unicorn.pid`
    # RESTART
    stop
    start
  end
end

# === Step:
#   更新代码, 创建current链接 -> current release(Cap内建recipe)
#
#   链接config/database.yml -> config/database.yml.example
#
#   设置RVM环境 (rvm内建recipe)
#
#   bundle install依赖的gem (bundle内建recipe)
#
#   precompile assets (Cap内建recipe，在Capfile里load)
#
#   重启服务
#
#   重启sidekiq (sidekiq内建recipe)
#
#
# === Sidekiq start command
# `nohup bundle  exec sidekiq -e production -C config/sidekiq.yml -P tmp/pids/sidekiq.pid >> log/sidekiq.log 2>&1 &`


# =======================================================================================
# Sidekiq on app to process local file system jobs, like snapshot, client file import.
# =======================================================================================
before "deploy:update_code", "sidekiq_on_app:quiet"
after  "deploy:stop",        "sidekiq_on_app:stop"
after  "deploy:start",       "sidekiq_on_app:start"
after  "deploy:restart",     "sidekiq_on_app:restart"

namespace :sidekiq_on_app do
  desc "Quiet sidekiq_on_app (stop accepting new work)"
  task :quiet, :roles => :app, :on_no_matching_servers => :continue do
    run "if [ -d #{current_path} ] && [ -f #{sidekiq_pid} ]; then cd #{current_path} && #{fetch(:bundle_cmd, "bundle")} exec sidekiqctl quiet #{sidekiq_pid} ; fi"
  end 

  desc "Stop sidekiq on app"
  task :stop, :roles => :app, :on_no_matching_servers => :continue do
    run "if [ -d #{current_path} ] && [ -f #{sidekiq_pid} ]; then cd #{current_path} && #{fetch(:bundle_cmd, "bundle")} exec sidekiqctl stop #{sidekiq_pid} #{fetch :sidekiq_timeout} ; fi"
  end 

  desc "Start sidekiq on app"
  task :start, :roles => :app, :on_no_matching_servers => :continue do
    rails_env = fetch(:rails_env, "production")
    run "cd #{current_path} ; nohup #{fetch(:bundle_cmd, "bundle")} exec sidekiq -e #{rails_env} -C #{current_path}/config/sidekiq_on_app.yml -P #{sidekiq_pid} >> #{current_path}/log/sidekiq.log 2>&1 &", :pty => false
  end 

  desc "Restart sidekiq"
  task :restart, :roles => :app, :on_no_matching_servers => :continue do
    stop
    start
  end 
end 
