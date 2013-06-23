require "sidekiq/web"
Skyeye::Application.routes.draw do
  get "home/index"

  get '/district' => 'district#index' # 返回树状结构的省，市，区县数据
  match '/district/:id', to: 'district#list' # 地区选择


  get "crimes/index"

  root :to => 'home#index'

  resources :seeks do 
    collection do 
      delete :delete_all
    end
  end

  resources :company_clients do
    collection do
      get :court_problem
      get :idinfo_problem
      post :create_with_company_and_company_owner
    end
    resources :client_relationships
  end
  
  resources :credits

  resources :companies do
    member do
      put :update_business
      put :update_company
    end

    collection do
      get :search
    end
  end

  post "/update_snapshot" => "company_clients#update_snapshot", :as => :update_snapshot
  put "/update_importer_temp" => "importers#update_importer_temp",:as=>:update_importer_temp
  post "/import_temp" => "importers#import_temp",:as=>:import_temp

  get '/statistics'=> 'statistics#index',:as => :statistics
  post '/statistics'=> 'statistics#index',:as => :statistics

  get '/users/alarm_config/edit' => "alarm_configs#edit",:as => :edit_user_alarm_config
  put '/users/alarm_config/update' => "alarm_configs#update",:as => :update_user_alarm_config

  devise_for :users, :controllers => {:registrations => "registrations"}

  # Mount sidekiq with constraint for security
  sidekiq_constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.admin? }
  constraints sidekiq_constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :alarms

  resources :exporters

  resources :activities


  resources :person_clients do
    resources :client_relationships
  end
  resources :people
  resources :list_files

  resources :importers 
  resources :messages do
    collection do
      get :read
      get :unread
      post :reading_some
      post :reading_all
      delete :destroy_some
    end
    member do
      post :reading
    end
  end

  namespace :admin do 
    resources :companies do
      resources :bills
    end
    resources :institutions
    resources :users
    resources :roles
  end
  require 'api'
  mount API::Root => "/"

  # mount SkyeyePower::Engine, :at => "/skyeye_power"
  # mount Workflow::Engine, :at => "/workflow"
  # mount Skyrole::Engine,:at => "skyrole"
end
