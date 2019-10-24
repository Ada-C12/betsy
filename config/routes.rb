Rails.application.routes.draw do
  root to: 'homepages#index'
  
  resources :orderitems, only: [:edit, :destroy]
  patch '/orderitems/:id', to: 'orderitems#update'
end
