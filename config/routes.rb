Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  devise_for :user, skip: [:sessions, :passwords], controllers: {
    registrations: "user/registrations",
  }
  # ログインページをトップページにするためにスコープで記述
  devise_scope :user do
    get '/' => 'user/sessions#new', as: 'new_user_session'
    post 'user/sign_in' => 'user/sessions#create', as: 'user_session'
    delete 'user/sign_out' => 'user/sessions#destroy', as: 'destroy_user_session'
    post 'user/guest_sign_in' => 'user/sessions#guest_sign_in'
  end

  namespace :admin do
    root to: 'homes#top'
    get 'search' => 'searches#search'
    get 'comments/destroy'
    resources :users, only: [:index, :show, :destroy]
    resources :posts, only: [:index, :show, :destroy] do
      delete '/comments/:id' => 'comments#destroy', as: 'comment'
    end
  end

  scope module: :user do
    get 'search' => 'searches#search'
    get 'posts/favorites' => 'favorites#index'
    get 'users/mypage' => 'users#mypage', as: 'mypage'
    get 'users/information/edit' => 'users#edit', as: 'edit_information'
    patch 'users/information' => 'users#update', as: 'update_information'
    delete 'users/information' => 'users#destroy', as: 'destroy_information'
    get 'users/:id' => 'users#show', as: 'show_user'
    post 'relationships/:id' => 'relationships#create', as: 'create_relationship'
    delete 'relationships/:id' => 'relationships#destroy', as: 'destroy_relationship'
    get 'followings/:id' => 'relationships#followings', as: 'followings'
    resources :posts do
      resources :comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
