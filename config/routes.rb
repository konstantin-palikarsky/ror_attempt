Rails.application.routes.draw do

  # get 'people/index'
  delete 'people/keywords', to: 'people#removekw'
  get 'people/full_report/:id', to: 'people#full_person_report'
  get 'people/print', to: 'people#printable_representation'
  get 'people/search', to: 'people#search'
  get 'people/favorites', to: 'people#favorites'
  post 'people', to: 'people#create'
  put 'people/annotations', to: 'people#annotate'
  put 'people/keywords', to: 'people#setkw'
  delete 'people', to: 'people#destroy'
  resources :people

  delete 'courses/keywords', to: 'courses#removekw'
  get 'courses/print', to: 'courses#printable_representation'
  get 'courses/search', to: 'courses#search'
  get 'courses/favorites', to: 'courses#favorites'
  post 'courses', to: 'courses#create'
  put 'courses/annotations', to: 'courses#annotate'
  put 'courses/keywords', to: 'courses#setkw'
  delete 'courses', to: 'courses#destroy'
  resources :courses

  delete 'projects/keywords', to: 'projects#removekw'
  get 'projects/print', to: 'projects#printable_representation'
  get 'projects/search', to: 'projects#search'
  get 'projects/favorites', to: 'projects#favorites'
  post 'projects', to: 'projects#create'
  put 'projects/annotations', to: 'projects#annotate'
  put 'projects/keywords', to: 'projects#setkw'
  delete 'projects', to: 'projects#destroy'
  resources :projects

  delete 'theses/keywords', to: 'theses#removekw'
  get 'theses/print', to: 'theses#printable_representation'
  get 'theses/search', to: 'theses#search'
  get 'theses/favorites', to: 'theses#favorites'
  post 'theses', to: 'theses#create'
  put 'theses/annotations', to: 'theses#annotate'
  put 'theses/keywords', to: 'theses#setkw'
  delete 'theses', to: 'theses#destroy'
  resources :theses

  get 'users/sign_in', to: 'users#sign_in'
  post 'users/sign_in', to: 'users#send_sign_in'
  post 'users/sign_out', to: 'users#sign_out'
  resources :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "people#search"
  root 'pages#home'
end
