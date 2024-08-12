Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'venues#index'

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'signup' }, controllers: { registrations: 'registrations' }

  # after signup
  resources :onboarding_steps
  # onboarding page
  get 'logout', to: 'pages#logout', as: 'logout'

  get 'dashboard/:id', to: 'dashboard#index', as: :dashboard

  resources :venues do
    collection do
      get 'categories/:categories', to: 'venues#categories', as: :categories
    end
  end
  resources :subscribe, only: [:index]
  resources :account, only: %i[index update] do
    get :stop_impersonating, on: :collection
  end
  resources :billing_portal, only: [:new, :create]
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
