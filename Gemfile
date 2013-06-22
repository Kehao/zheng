source 'http://ruby.taobao.org'

gem 'rails', '3.2.13'
gem 'mysql2'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'flatui-rails'
end

group :development, :test do
  gem 'quiet_assets'
  
  gem 'rails-erd'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'spork', '~> 1.0rc' # rpsec drb server
  gem "spork-rails"
  gem 'guard-spork'
  gem 'pry-rails'

  # Show scheme in model files
  # Annotate gem have a rake uncompatible bug, so use other annotate patch branch
  gem 'annotate', :git => 'git://github.com/jeremyolliver/annotate_models.git', :branch => 'rake_compatibility'
  gem 'debugger'

  gem "better_errors"
  gem "binding_of_caller"
end

## model query ================
gem 'ransack'
gem 'kaminari'
gem 'area_cn', '~> 0.0.6'
gem 'enumerize', '~> 0.5.1'

gem "attribute_normalizer" # Clean attributes
gem "spreadsheet", "~> 0.6.8" # excel process
gem 'roo'

## controller =================
gem 'decent_exposure' 

## server run time =============
gem 'thin'

## viewer ======================
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'simple_form'
gem 'rabl'
gem 'cells'
#gem 'twitter-bootstrap-rails', ">= 2.1.8"
gem 'bootstrap-editable-rails'
gem 'therubyracer'
gem 'less-rails'

## users =======================
gem 'devise'
gem 'cancan'

## uploader ====================
gem 'carrierwave'

## spider ======================
# sidekiq background spider jobs
gem 'sidekiq', '~> 2.5.3'
gem 'sinatra', :require=>false
gem 'slim'

# for spider requirement
gem 'nokogiri'
gem 'sqider', :path => "lib/plugins"
gem 'snapshot', :path => "lib/plugins"

## faye asyn-link ==============
gem 'faye'

## cron jobs ================
gem 'whenever', :require => false

#用于保存配置型(枚举)记录 =====
#全局配置
gem 'active_hash' 

# Deploy ============
gem "unicorn"
gem "capistrano"
gem "rvm-capistrano"

#extensions ========
gem 'skyeye_power',  :path => "extensions/skyeye_power"
# gem 'skyeye_apollo', :path => "extensions/skyeye_apollo"
# gem 'workflow', :path => "extensions/workflow"

# gem 'rack-mini-profiler'

gem 'prawn'

#gem 'wisepdf'
#gem 'wkhtmltopdf-binary'

gem 'to_xls'

# message engine
#gem 'public_activity'

#gem 'grape-entity',:git=> "git://github.com/intridea/grape-entity.git"

gem 'grape'
gem 'grape-rabl'
gem 'grape-swagger',:git => "git://github.com/jhecking/grape-swagger.git"

# gem 'ruby-oci8'
# gem 'activerecord-oracle_enhanced-adapter'
