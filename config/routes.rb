Rails.application.routes.draw do
  passwordless_for :users
  resources :posts
  get '/', to: 'posts#feed'
  get '/feed', to: 'posts#feed'
  get '/error', to: 'error#error', as: :error
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
