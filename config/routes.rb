Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  # get 'users/show'
  root 'hello#index'
  post '/hello/guest_sign_in', to: 'hello#new_guest'
  
  # root "users#index"
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  
  get  'static_pages/home'
  get  'static_pages/help'
  get 'hello/index' => 'hello#index'
  get 'hello/link' => 'hello#link'
  # get 'missions' => 'missions#index'
  # get 'missions/new' => 'missions#new'
  # post 'missions' => 'missions#create'
  # get 'missions/:id' => 'missions#show',as: 'mission'
  # patch 'missions/:id' => 'missions#update'
  # delete 'missions/:id' => 'missions#destroy'
  # get 'missions/:id/edit' => 'missions#edit', as:'edit_mission'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # resources :missions 
  # root 'missions#index'

  
  # devise_scope :user do
  #   post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  # end

  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :missions do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

    # resources :users, only: [:index, :show]
    resources :messages, only: [:create, :edit, :update, :destroy]
    resources :relationships, only: [:create, :destroy]
    resources :rooms, only: [:create, :index, :show]
    resources :notifications, only: [:index, :update]
end