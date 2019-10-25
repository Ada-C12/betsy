Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :merchants, except: [:delete, :new]
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  
  get "merchants/current", to: "merchant#current", as: "current_merchant"
  
  root to: 'homepages#index'
  
  resources :orderitems, only: [:edit, :destroy]
  patch '/orderitems/:id', to: 'orderitems#update'
  resources :products
end
