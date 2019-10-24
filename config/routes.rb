Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "products#index"
  
  get "/wizards/:id/products", to: "wizards#products", as: "wizards_products"

  resources :products
  resources :categories do
    resources :products, only: :index
  end

end
