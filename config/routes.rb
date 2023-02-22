Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :merchants, only: [:show] do
  #   resources :dashboard, only: [:index]
  # end
  
  get '/merchants/:id/dashboard', to: "dashboard#index"
  get '/merchants/:id/items', to: "items#index"
  get '/merchants/:id/invoices', to: "invoices#index"
end
