Rails.application.routes.draw do
  
  resources :merchants, except: [:delete, :new, :show]
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "merchants/current", to: "merchants#current", as: "current_merchant"
  
  
  root to: 'homepages#index'
  
  resources :orderitems, only: [:edit, :destroy]
  patch '/orderitems/:id', to: 'orderitems#update'
  
  resources :products do
    resources :orderitems, only: [:create]
  end
  
  resources :orders, only: [:show, :edit]
  patch '/orders/:id', to: 'orders#update'
  patch '/orders/:id/cancel', to: 'orders#cancel', as: "cancel_order"
end
