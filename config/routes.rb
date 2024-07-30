Rails.application.routes.draw do
  # get 'book_comments/create'
  # get 'book_comments/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

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

  get 'search' => "searches#search"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
