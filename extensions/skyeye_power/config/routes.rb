SkyeyePower::Engine.routes.draw do
  root :to => "home#index"

  resources :companies do
    resources :bills
    resources :water_company_accounts 
    resources :elec_company_accounts 
    resources :bills 
  end

  resources :water_company_accounts do 
    resources :bills 
  end

  resources :elec_company_accounts do 
    resources :bills 
  end

  namespace :admin do 
    root :to => "home#index"
    resources :companies do
      resources :bills
      resources :water_company_accounts 
      resources :elec_company_accounts 
    end

    resources :water_company_accounts do 
      resources :bills 
    end

    resources :elec_company_accounts do 
      resources :bills 
    end
  end

end
