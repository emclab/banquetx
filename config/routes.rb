Banquetx::Engine.routes.draw do
  resources :banquets do
    collection do
      get :search
      get :search_results
    end
    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('banquet_wf_route', 'banquetx')  #nil if route defined in FactoryGirl which is loaded after route is loaded.
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?  #for rsepc. routes loaded before FactoryGirl.
      member do
        get :event_action
        patch :submit
        patch :acknowledge
      end
      
    end
  end
  resources :menus do
    collection do
      get :search
      get :search_results
    end
  end
  
  root :to => 'banquets#index'
end
