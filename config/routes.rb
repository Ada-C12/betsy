Rails.application.routes.draw do
  
  resources :orders do
    resources :orderproducts, only: [:update]
  end
  get "/confirmation/:id", to: "orders#confirmation", as: "confirmation"
  
  resources :orderproducts, except: [:create]
  
  root "homepages#index"
  
  resources :products do
    resources :orderproducts, only: [:create, :destroy]
    resources :reviews, only: [:new, :create]
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :merchants
  
  resources :categories
  
  get "/merchants/current", to: "merchants#current", as: "current_merchant"
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  
  get "/merchants/:id/fulfillment", to: "merchants#fulfillment", as: "fulfillment"
end
