# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root 'pages#todos', as: :authenticated_root
  end
  root 'pages#home'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :projects, only: %i[index show create update destroy] do
        resources :todos, only: %i[index show create update destroy]
      end
      resources :todos, only: %i[show] do
        resource :position do
          patch :up, on: :member
          patch :down, on: :member
        end
      end
    end
  end
end
