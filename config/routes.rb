Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'
  patch '/products/:id/toggle_retire', to: 'products#toggle_retire', as: 'toggle_retire_product'
  resources :products, except: [:destroy]
  
  
  resources :merchants, except: [:delete, :new]
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  get "merchants/current", to: "merchant#current", as: "current_merchant"
end
