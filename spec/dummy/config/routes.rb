Rails.application.routes.draw do

  mount Banquetx::Engine => "/banquetx"
  mount Authentify::Engine => '/auth'
  mount Commonx::Engine => '/common'
  mount Searchx::Engine => '/search'
  mount BanquetCoursex::Engine => '/course'
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
