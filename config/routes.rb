Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :concerts, only: %i[index show]
  resources :artists, only: %i[index show]
  resources :followed_artists, only: %i[index create destroy]
  resources :saved_concerts, only: %i[index create destroy]
  resources :users, only: :show

  post "saved_concerts", to: "saved_concerts#create", as: :save_this_concert

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
