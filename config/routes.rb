Rails.application.routes.draw do
  resources :posts
  get '/feed', to: 'posts#feed'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
