Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :merchants, except: [:destroy]
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  root to: 'homepages#index'
  resources :products, except: [:destroy]
  patch '/products/:id/toggle_retire', to: 'products#toggle_retire', as: 'toggle_retire_product'
end
