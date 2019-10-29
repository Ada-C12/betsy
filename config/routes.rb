Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  
  root to: "products#homepage"
  
  resources :products, only: [:index, :show] do
    resources :order_items, only: [:create]
    resources :reviews, only: [:new,:create]
  end

  get "/checkout/:id", to: "orders#checkout", as: "checkout"
  resources :orders, only: [:update]
  
  resources :order_items, only: [:update, :destroy]
  get "/cart", to: "orders#cart", as: "cart"
  
  resources :wizards do
    resources :products, only: [:index]
  end
  
  resources :categories do
    resources :products, only: [:index]
  end

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "wizards#create"
  delete "/logout", to: "wizards#destroy", as: "logout"
end
