# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'welcome#index'
  resources :users do
    post '/signup', to: 'users#signup', on: :collection
    post '/signin', to: 'users#signin', on: :collection
    get '/profile', to: 'users#profile', on: :collection
  end

  resources :companies, only: %i[create index]
  resources :resumes, only: %i[create update]
  resources :resume_human_resources, only: %i[create index]
  resources :human_resources, only: %i[create index]
end
