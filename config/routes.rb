# frozen_string_literal: true

RailsOpsDashboard::Engine.routes.draw do
  root to: 'dashboard#index'

  resources :seeds, only: [:index] do
    collection do
      post :execute
      get :status
    end
  end

  resources :rake_tasks, only: [:index] do
    collection do
      post :execute
      get :status
    end
  end

  resource :environment, only: [:show]

  resources :workers, only: [:index] do
    member do
      post :start
      post :stop
    end
  end

  delete :logout, to: 'sessions#destroy'
end
