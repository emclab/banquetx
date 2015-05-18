Banquetx::Engine.routes.draw do
  resources :banquets do
    collection do
      get :search
      get :search_results
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
