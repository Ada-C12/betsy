Rails.application.routes.draw do
  root to: 'homepages#index'
  
  resources :types, only: [:show, :new, :create]
  
  patch '/products/:id/toggle_retire', to: 'products#toggle_retire', as: 'toggle_retire_product'
  resources :products, except: [:destroy] do
    resources :orderitems, only: [:create]
    resources :reviews, only: [:new, :create]
  end
  
  resources :merchants, except: [:delete, :new, :show]
  get '/merchants/:id/products', to: 'products#merchant_products', as: 'merchant_products'
  get '/merchants/:id/orderitems', to: 'merchants#merchant_orderitems', as: 'your_orderitems'
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "merchants/current", to: "merchants#current", as: "current_merchant"
  
  resources :orderitems, only: [:edit, :destroy]
  patch '/orderitems/:id', to: 'orderitems#update'
  patch '/orderitems/:id/mark_shipped', to: 'orderitems#mark_shipped', as: 'mark_shipped'
  
  resources :orders, only: [:show, :edit]
  get '/cart', to: 'orders#cart', as: 'cart'
  patch '/orders/:id', to: 'orders#update'
  patch '/orders/:id/cancel', to: 'orders#cancel', as: 'cancel_order'
  get '/orders/:id/merchant_order', to: 'orders#merchant_order', as: 'merchant_order'
  
  
end
