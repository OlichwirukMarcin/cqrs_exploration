Rails.application.routes.draw do
  resources :users
  resources :products
  resources :basket, only: [:create, :index, :update]
  get '/login', to: 'users#login_view', as: 'login'
  post '/login', to: 'users#login', as: 'login_user'
  get '/logout', to: 'users#logout', as: 'logout'
end
