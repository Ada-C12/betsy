Rails.application.routes.draw do
  
  root to: 'homepages#index'
  
  resources :users, only:[:show, :index, :destroy]
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"
  get "/cart", to: "orders#cart", as: "cart"
  get "/checkout", to: "orders#checkout", as: "checkout"
  post "/orders/:id", to: "orders#complete", as: "complete_order"
  get "/dashboard", to: "users#dashboard", as: "dashboard"
  get "/confirmation", to: "orders#confirmation", as: "confirmation"
  patch "/orders/:id/complete", to: "orders#update_status", as: "update_status"
  
  resources :products, except: :destroy do
    resources :order_items, only: [:new, :create]
    resources :reviews, except: [:index, :show, :destroy]
  end
  
  resources :categories, except: :destroy
  
  resources :orders do
    resources :order_items, only: [:edit, :update, :destroy]
  end
  
  
  
  
end
