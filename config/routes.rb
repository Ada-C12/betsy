Rails.application.routes.draw do
  get 'orders/index'
  get 'orders/new'
  get 'orders/create'
  get 'orders/update'
  get 'orders/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :merchants, except: [:delete]
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  root to: 'homepages#index'
  resources :products
end
