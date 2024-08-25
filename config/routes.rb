Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'venues#index'

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'signup' }, controllers: { registrations: 'registrations' }

  # after signup
  resources :onboarding_steps
  # onboarding page
  get 'logout', to: 'pages#logout', as: 'logout'

  get 'dashboard/:id', to: 'dashboard#index', as: :dashboard
  get 'dashboard/:id/my_venues', to: 'dashboard#my_venues', as: :my_venues
  get 'dashboard/:id/my_venue_packages', to: 'dashboard#my_venue_packages', as: :my_venue_packages
  get 'dashboard/:id/edit', to: 'dashboard#edit', as: :edit_dashboard
  patch 'dashboard/:id', to: 'dashboard#update', as: :update_dashboard
  get 'checkout', to: 'checkouts#show'
  get 'checkout/success', to: 'checkouts#success'
  get 'checkout/cancel', to: 'checkouts#cancel'

  post 'webhooks', to: 'webhooks#create'


  resources :venues do
    resources :packages, only: %i[ new create index show] do
      resources :bookings, only: %i[ new create]
    end
    collection do
      get 'categories/:categories', to: 'venues#categories', as: :categories
    end

  end

  resources :bookings, except: %i[ new create ]
  resources :packages, except: %i[ new create index show]
  resources :subscribe, only: [:index]
  resources :account, only: %i[index update] do
    get :stop_impersonating, on: :collection
  end
  resources :billing_portal, only: [:new, :create, :show]
  resources :blog_posts, controller: :blog_posts, path: "blog", param: :slug

  # static pages
  pages = %w[
    privacy terms onboarding home
  ]

  pages.each do |page|
    get "/#{page}", to: "pages##{page}", as: page.gsub('-', '_').to_s
  end

  # admin panels
  authenticated :user, ->(user) { user.admin? } do
    # insert sidekiq etc
    mount Split::Dashboard, at: 'admin/split'
  end
end
