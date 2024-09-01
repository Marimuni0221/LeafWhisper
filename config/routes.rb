# frozen_string_literal: true

Rails.application.routes.draw do
  # 固定URLでOmniAuthのコールバックルートを定義
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope '(:locale)', locale: /en|ja/ do
    get 'faqs/index'
    get 'cafes/search'
    devise_for :users, skip: :omniauth_callbacks, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

    # Health status check
    get 'up' => 'rails/health#show', as: :rails_health_check

    get 'products/search', to: 'products#search', as: 'search_products'
    get '/terms', to: 'static_pages#terms'
    get '/privacy', to: 'static_pages#privacy'
    root 'static_pages#top'

    resources :products, param: :item_url, shallow: true do
      resources :reviews, only: %i[new create destroy]
      resources :favorites, only: %i[create destroy]
    end

    resources :cafes, shallow: true, only: [] do
      resources :favorites, only: %i[create destroy]
      member do
        get 'favorite_button'
      end
      collection do
        post 'save'
        get 'search'
      end
    end

    resources :users, only: [] do
      member do
        get :reviews
      end
    end

    resources :contacts, only: %i[new create]

    resources :favorites, only: %i[index create destroy]

    resources :faqs, only: %i[index]
  end
end
