Rails.application.routes.draw do

  root "homepages#index"

  resources :products

  get "/orders/shopping_cart", to: "orders#shopping_cart", as: "shopping_cart"

  get "/orders/:id/confirmation_page", to: "orders#confirmation_page", as: "confirmation_page"

  resources :orders

  get "/orders/remove_product_from_cart/:id", to: "orders#remove_product_from_cart", as: "remove_product_from_cart"

  # get "/orders/change_quantity_of_cart/:id", to: "orders#change_quantity_of_cart", as: "change_quantity_of_cart"

  resources :order_items

  # resources :categories

  
  resources :merchants do
    resources :products, only: [:index, :new]
    resources :orders, only: [:index]
  end

  resources :categories, only: [:new, :create] do
    resources :products, only: [:index]
  end

  # nested reviews under products
  resources :products do
    resources :reviews, only: [:new, :create]
  end

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#destroy", as: "logout"
  get "/merchants/current", to: "merchants#current", as: "current_merchant"

  patch "/products/:id/active", to: "products#toggle_active", as: "toggle_active"

  root 'homepages#index'

  # get "/orders/:id/create_confirmation", to: "orders#create_confirmation", as: "create_confirmation"

  patch "/products/:id/inactive", to: "products#toggle_inactive", as: "toggle_inactive"

  post "/products/:id/add_product_to_cart", to: "products#add_product_to_cart", as: "add_product_to_cart" 
end

