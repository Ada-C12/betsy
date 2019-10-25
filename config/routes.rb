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
end
