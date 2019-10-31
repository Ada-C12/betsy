Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "products#homepage"
  
  resources :products, only: [:index, :show] do
    resources :order_items, only: [:create]
    resources :reviews, only: [:new,:create]
  end
  
  
  resources :orders, only: [:update]
  get "/checkout/:id", to: "orders#checkout", as: "checkout"
  get "/confirmation/:id", to: "orders#confirmation", as: "confirmation"
  
  resources :order_items, only: [:update, :destroy]
  get "/cart", to: "orders#cart", as: "cart"
  patch "/shipped/:id", to: "order_items#shipped", as: "shipped"
  
  resources :wizards, only: [:show] do
    resources :products, only: [:index]
  end
  
  resources :categories, only: [:new, :create] do
    resources :products, only: [:index]
  end
  
  patch 'products/:id/make_retired_true', to: 'products#make_retired_true', as: 'make_retired_true'
  patch 'products/:id/make_retired_false', to: 'products#make_retired_false', as: 'make_retired_false'
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "wizards#create", as: "auth_callback"
  delete "/logout", to: "wizards#destroy", as: "logout"
end
