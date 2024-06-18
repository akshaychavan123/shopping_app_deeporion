Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      post 'auth/login', to: 'authentication#login'

      resources :orders, only: [:create]

      resources :wishlists, only: [] do
        get ':user_id', to: 'wishlists#show', on: :collection
        resources :wishlist_items, only: [:create, :destroy] do
          post 'add_to_cart', on: :collection
        end
      end

       resource :cart, only: [:show] do
        resources :cart_items, only: [:index, :update] do
          collection do
            post 'add_item'
            delete 'remove_or_move_to_wishlist'
          end
        end
      end
    end

    namespace :v2 do
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :categories do
        resources :subcategories, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
