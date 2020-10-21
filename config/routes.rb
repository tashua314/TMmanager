Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  root 'hello#index'
  post '/hello/guest_sign_in', :to => 'hello#new_guest'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :passwords => 'users/passwords'
  }
  
  get  'static_pages/home'
  get  'static_pages/help'
  get 'hello/index' => 'hello#index'
  get 'hello/link' => 'hello#link'
  

  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :missions do
    resources :likes, :only => [:create, :destroy]
    resources :comments, :only => [:create, :destroy]
  end

    # resources :users, only: [:index, :show]
    resources :messages, :only => [:create, :edit, :update, :destroy]
    resources :relationships, :only => [:create, :destroy]
    resources :rooms, :only => [:create, :index, :show]
    resources :notifications, :only => [:index, :update]
end