Rails.application.routes.draw do
  resources :orders#, except: [:put]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "products#index"
  
  resources :products
  
  resources :merchants
  get "/login", to: "merchants#login_form", as: "login"
  post "/login", to: "merchants#login"
  post "/logout", to: "merchants#logout", as: "logout"
  get "/merchants/current", to: "merchants#current", as: "current_merchant"
end
