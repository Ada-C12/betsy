Rails.application.routes.draw do
  root to: 'homepages#index'
  
  patch '/products/:id/toggle_retire', to: 'products#toggle_retire', as: 'toggle_retire_product'
  resources :products, except: [:destroy] do
    resources :orderitems, only: [:create]
  end

  resources :merchants, except: [:delete, :new, :show] do
    resources :products, only: [:index]
  end 
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "merchants/current", to: "merchants#current", as: "current_merchant"
  
  resources :orderitems, only: [:edit, :destroy]
  patch '/orderitems/:id', to: 'orderitems#update'
  get 'merchant_products' => 'products#index', as: :filtered_products
  patch '/orderitems/:id/mark_shipped', to: 'orderitems#mark_shipped', as: 'mark_shipped'
  
  resources :orders, only: [:show, :edit]
  get '/cart', to: 'orders#cart', as: 'cart'
  patch '/orders/:id', to: 'orders#update'
  patch '/orders/:id/cancel', to: 'orders#cancel', as: 'cancel_order'
end
