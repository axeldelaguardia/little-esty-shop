Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get '/', to: "welcome#index"

  resources :admin, only: :index

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
		resources :invoices, only: [:index, :show]
  end

  get '/merchants/:id/dashboard', to: "merchants#show", as: 'merchant_dashboard'

	resources :merchants, only: :show do
		resources :items, except: :update, controller: 'merchants/items'
    resources :invoices, only: [:index, :show], controller: 'merchants/invoices'
		resources :bulk_discounts, except: :update, controller: 'merchants/bulk_discounts'
	end

	patch '/merchants/:merchant_id/bulk_discounts/:id', to: "merchants/bulk_discounts#update"
  patch '/merchants/:merchant_id/invoices/:id', to: 'merchants/invoice_items#update'
	patch '/merchants/:merchant_id/items/:id', to: "merchants/items#update"
	patch '/admin/merchants/:id', to: "admin/merchants#update"
  patch '/admin/invoices/:id', to: "admin/invoices#update"

end
