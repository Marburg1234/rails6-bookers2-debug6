Rails.application.routes.draw do


   devise_for :users

  root to: "homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    # フォロー機能用のルーティングを追加
    resource :relationships, only: [:create, :destroy]
    #フォローしている人の一覧ページへのルーティング
    get :follows, on: :member
    # フォローしてくれている人の一覧ページへのルーティング
    get :followers, on: :member
  end

  resources :chats, only: [:show, :create, :destroy]

  get 'search' => "searches#search"

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  resources :notifications, only: [:update]

  resources :groups, only: %i[index new show create edit update destroy]

end
