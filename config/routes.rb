Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products
  # resources :products do 
  #   member do 
  #     post 'rate_product'
  #   end 
  # end
end
