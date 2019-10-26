Rails.application.routes.draw do
  root "homepages#index"
  
  resources :products

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  get "/users/current", to: "users#current", as: "current_user"
  get "/users/current/edit", to: "users#edit", as: "edit_user"
  # patch "/users/current", to: "users#update"

  resources :users, only: [:show, :update]

  resources :order, only: [:show, :update]
  get "/orders/cart", to: "orders#cart", as: "cart"
  get "/orders/confirmation", to: "orders#confirmation", as: "confirmation"
  
end
