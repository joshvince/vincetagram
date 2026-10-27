# frozen_string_literal: true

Rails.application.routes.draw do
  get '/up', to: 'health_check#up'
  passwordless_for :users, at: '/', as: 'auth' # this is the sign in routes
  resources :posts
  get '/', to: 'posts#feed'
  get '/feed', to: 'posts#feed'
  get '/feed/post/:id', to: 'posts#feed_post', as: 'feed_post'
  get '/error', to: 'error#error', as: :error
  resources :users do
    resource :sign_in_link, only: :create
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
