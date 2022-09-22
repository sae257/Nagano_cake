Rails.application.routes.draw do

# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  namespace :admin do
    get '' => 'homes#top'
    resources :items, only: [:show, :index, :new, :edit, :create, :update]
    resources :customers, only: [:index, :show, :edit, :update] do
      get "search_order/:id" => "customers#search_order", as: 'search_order'
    end
    resources :orders, only: [:show, :update] do
      resources :order_items,only: [:update]
    end
    resources :genres, only: [:index, :create, :edit, :update]
  end

  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
      post '/confirm' => 'orders#confirm'
      get '/thanks' => 'orders#thanks'
      end
    end

    resources :cart_items, only: [:index, :update, :create, :destroy] do
      delete 'cart_items/all_destroy' =>'cart_items#all_destroy'
    end

    resources :items, only: [:index, :show]

    resources :customers,only:[:show, :edit, :update] do
      collection do
        get 'unsubscribe'
        patch 'withdrawal'
      end
    end
    get 'customers/my_page' => 'customers#show'
    get 'customers/infomation/edit' => 'customers#edit'
    patch 'customers/infomation' => 'customers#update'

    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
    resources :genres, only: [:show]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end