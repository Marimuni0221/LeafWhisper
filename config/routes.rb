Rails.application.routes.draw do
  get 'cafes/search'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  get 'products/search', to: 'products#search', as: 'search_products'
  get '/terms', to: 'static_pages#terms'
  get '/privacy', to: 'static_pages#privacy'
  
  resources :products, param: :item_url do
    resources :reviews, only: %i[new create destroy]
  end
  
  resources :cafes, only: [] do
    collection do
      get 'search'
    end
  end

  resources :contacts, only: %i[new create]

  resources :users, only: [] do
    member do
      get :reviews  # /users/:id/reviews
    end
  end
  
  root "static_pages#top"
end
