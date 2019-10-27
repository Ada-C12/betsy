Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants, except: [:delete, :new, :show] do
    resources :orderitems, only: [:index]
  end


  root to: 'homepages#index'
  patch '/products/:id/toggle_retire', to: 'products#toggle_retire', as: 'toggle_retire_product'
  resources :products, except: [:destroy] do
    resources :orderitems, only: [:create]
  end



  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "merchants/current", to: "merchants#current", as: "current_merchant"

  resources :orderitems, only: [:edit, :destroy]
  patch '/orderitems/:id', to: 'orderitems#update'
end
