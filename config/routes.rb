Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    namespace :v1 do
      resources :reviews, only: [:create, :index]
      resources :review_votes, only: [:create]

      root to: 'home#index'
      resources :home, only: [:index]
      
      post 'passwords/forgot', to: 'passwords#forgot'
      post 'passwords/reset', to: 'passwords#reset'

      post 'auth/create', to: 'authentication#create'
      post 'auth/verify', to: 'authentication#verify'

      post '/auth/google_oauth2', to: 'sessions#google_auth'

      resources :users, only: [:create] do
        member do
          patch :update_image
          delete :delete_image
          patch :update_profile
          get :show_profile
        end
      end

      post 'auth/login', to: 'authentication#login'

      get 'landing_page/categories_index', to: 'landing_page#categories_index'
      get 'landing_page/index_with_subcategories_and_products', to: 'landing_page#index_with_subcategories_and_products'    
      # get 'landing_page/sub_categories_index', to: 'landing_page#sub_categories_index'
      get 'landing_page/product_items_by_category/:id', to: 'landing_page#product_items_by_category', as: 'landing_page_product_items_by_category'
      get 'landing_page/products_index', to: 'landing_page#products_index'
      get 'landing_page/product_items_index', to: 'landing_page#product_items_index'
      get 'landing_page/gift_cards_index', to: 'landing_page#gift_cards_index'
      get 'landing_page/gift_cards_category', to: 'landing_page#gift_cards_category'
      get 'landing_page/gift_cards_by_category/:id', to: 'landing_page#gift_cards_by_category'
      get '/landing_page/product_items_of_product/:id', to: 'landing_page#product_items_of_product'
      get '/landing_page/product_items_show/:id', to: 'landing_page#product_items_show'
      get '/landing_page/product_items_filter', to: 'landing_page#product_items_filter'
      get '/landing_page/product_items_search', to: 'landing_page#product_items_search'
      get '/landing_page/new_arrivals', to: 'landing_page#new_arrivals'
      get '/landing_page/index_of_product_by_category/:id', to: 'landing_page#index_of_product_by_category'     

      resources :orders, only: [:create]
      resources :contact_us, only: [:create]

      resources :wishlists, only: [] do
        get 'show_wishlistitems', to: 'wishlists#show_wishlistitems', on: :collection
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
      resources :product_item_variants, only: [:create]
      resources :product_items, only: [:index, :show, :create, :update, :destroy] 
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :terms_and_conditions, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: [:index, :show, :create, :update, :destroy] do
        # resources :product_items, only: [:index, :show, :create, :update, :destroy] 
      end
      resources :categories do
        resources :subcategories, only: [:index, :show, :create, :update, :destroy]
      end
      resources :gift_card_categories, only: [:index, :show, :create, :destroy]
      resources :gift_cards
      resources :coupons, only: [:index, :show, :create]
    end
  end
end
