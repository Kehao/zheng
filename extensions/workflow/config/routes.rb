Workflow::Engine.routes.draw do
  namespace :admin do 
    match "/" => "workflows#edit"
    match 'workflows', :controller => 'workflows', :action => 'index', :via => :get
    match 'workflows/edit', :controller => 'workflows', :action => 'edit', :via => [:get, :post]
    # resources :workflows
    resources :trackers
    resources :statuses
  end
end
