Rails.application.routes.draw do
  root "homepages#index"
  

  
  resources :products

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  get "/users/current", to: "users#current", as: "current_user"
  get "/users/current/edit", to: "users#edit", as: "edit_user"

  resources :users, only: [:show, :update]

  resources :orders, only: [:show, :update]
  get "/orders/cart", to: "orders#cart", as: "cart"
  get "/orders/checkout", to: "orders#checkout", as: "checkout"
  get "/orders/confirmation", to: "orders#confirmation", as: "confirmation"
  
  resources :categories do
    resources :products, only: [:index]
  end
  
  resources :users do
    resources :products, only: [:index]
  end

end
