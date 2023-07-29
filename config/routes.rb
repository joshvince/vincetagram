Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: 'auth' #this is the sign in routes
  get '/manual_sign_in', to: 'manual_sign_in#sign_in_with_token', as: 'manual_sign_in'
  resources :posts
  get '/', to: 'posts#feed'
  get '/feed', to: 'posts#feed'
  get '/feed/post/:id', to: 'posts#feed_post', as: 'feed_post'
  get '/error', to: 'error#error', as: :error
  resources :users

  # Service worker related stuff
  get '/service-worker.js' => "service_worker#service_worker"
  get '/manifest.json' => "service_worker#manifest"
  post '/add_subscription' => "service_worker#add_subscription"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
