Rails.application.routes.draw do
  root "homepages#index"
  resources :products

end
