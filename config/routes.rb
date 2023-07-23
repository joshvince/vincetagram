Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: 'auth'
  resources :posts
  get '/', to: 'posts#feed'
  get '/feed', to: 'posts#feed'
  get '/error', to: 'error#error', as: :error
  resources :users

  # Service worker related stuff
  get '/service-worker.js' => "service_worker#service_worker"
  get '/manifest.json' => "service_worker#manifest"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
