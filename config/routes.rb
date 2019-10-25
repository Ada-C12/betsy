Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 
  root to: "products#index"
 
  resources :products, only: [:index, :show]

  resources :wizards do
    resources :products, only: [:index]
  end

  resources :products do 
    resources :reviews, only: [:new,:create]
  end 

  
  resources :categories do
    resources :products, only: [:index]
  end

end
