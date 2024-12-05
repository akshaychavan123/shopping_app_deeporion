Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    namespace :v1 do
      resources :help_centers
      resources :notification, only: [:update] do 
        collection do
            get 'show_notification'
        end
      end
      resources :reviews, only: [:create, :index] 
      resources :plans, only: [:index, :show, :create, :update, :destroy]
      resources :instagramposts
      resources :review_votes, only: [:create]
      resources :addresses
      resources :order_items, only: [:index, :update, :destroy] do
        collection do
          get 'pending_orders/:status', to: 'order_items#pending_orders'
          get 'order_count', to: 'order_items#order_count'
          get 'order_status_graph', to: 'order_items#order_status_graph'
          get 'revenue_graph', to: 'order_items#revenue_graph'          
        end
      end
      resource :card_details, only: [:index, :show, :create, :update, :destroy]
      resources :card_orders, only: [:create]
      resources :client_reviews, only: [:index, :create, :update, :destroy]

      root to: 'home#index'
      resources :home, only: [:index]
      
      post 'passwords/forgot', to: 'passwords#forgot'
      post 'passwords/reset', to: 'passwords#reset'

      post 'auth/create', to: 'authentication#create'
      post 'auth/verify', to: 'authentication#verify'

      post '/auth/google_oauth2', to: 'sessions#google_auth'

      resources :users, only: [:create, :destroy] do
        collection do
          get :user_details
          patch :update_password
          patch :update_personal_details
        end
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
      get '/landing_page/product_items_by_sub_category/:id', to: 'landing_page#product_items_by_sub_category'
      get '/landing_page/product_items_show/:id', to: 'landing_page#product_items_show'
      get '/landing_page/product_items_filter', to: 'landing_page#product_items_filter'
      get '/landing_page/product_items_search', to: 'landing_page#product_items_search'      
      get '/landing_page/recent_viewed_product_items', to: 'landing_page#recent_viewed_product_items'
      get '/landing_page/new_arrivals', to: 'landing_page#new_arrivals'
      get '/landing_page/top_category', to: 'landing_page#top_category'      
      get '/landing_page/index_of_product_by_category/:id', to: 'landing_page#index_of_product_by_category'     
      get '/landing_page/filter_data_for_mobile', to: 'landing_page#filter_data_for_mobile'     
      
      resources :orders, only: [:create] do
        resources :returns, only: [:create]
      
        collection do
          post 'callback'
          post 'cancel'
          get 'order_history'
        end
      end
      
      resources :contact_us, only: [:create]

      resources :wishlists, only: [] do
        get 'show_wishlistitems', to: 'wishlists#show_wishlistitems', on: :collection
        resources :wishlist_items, only: [:create, :destroy] do
          post 'add_to_cart', on: :collection
        end
      end

       resource :cart, only: [:show] do
         get 'discount_on_amount_coupons', on: :collection
         post 'apply_coupon', to: 'carts#apply_coupon'
         get 'product_item_list_by_coupon/:id', to: 'carts#product_item_list_by_coupon', as: :product_item_list_by_coupon
         resources :cart_items, only: [:index, :update] do
          collection do
            post 'add_item'
            delete 'remove_or_move_to_wishlist'
          end
        end
      end

      resources :user_notifications, only: [:index, :show] do
        patch :mark_as_read, on: :member
      end
    end

    namespace :v2 do
      get 'product_items/admin_product_list/:product_id', to: 'product_items#admin_product_list'
      resources :product_item_variants, only: [:create, :update]
      resources :product_items, only: [:index, :show, :create, :update, :destroy] 
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :terms_and_conditions, only: [:index, :show, :create, :update, :destroy]
      resources :about_us, only: [:index, :show, :create, :update, :destroy]
      resources :privacy_policies, only: [:index, :show, :create, :update, :destroy]
      resources :exchange_return_policies, only: [:index, :show, :create, :update, :destroy]
      resources :shipping_policies, only: [:index, :show, :create, :update, :destroy]
      resources :video_libraries, only: [:index, :show, :create, :update, :destroy]
      resources :careers, only: [:index, :show, :create, :update, :destroy]
      resources :banners
      resources :career_roles
      resources :video_descriptions
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :client_review_comments, only: [:index, :create, :update, :destroy] do
        member do
          delete :delete_review
          patch :hide_review
        end
      end
      resources :categories do
        resources :subcategories, only: [:index, :show, :create, :update, :destroy]
      end
      resources :gift_card_categories, only: [:index, :show, :create, :update, :destroy]
      resources :gift_cards
      resources :coupons, only: [:index, :show, :create, :update, :destroy] do
        member do
          get :product_list
        end
      end
      resources :image_uploaders, only: [:index, :show, :create, :destroy] do
        collection do
          get 'images_by_name'
        end
      end
      resources :product_review_manage, only: [:index, :destroy]  do
        member do
          patch 'hide_review', action: :hide_review
          get 'product_reviews', action: :product_reviews
        end
      end
      resources :contact_us_manage, only: [:index, :show, :update]

      resources :subscriptions, only: [:index, :show, :create, :update, :destroy]
      post 'payments/create_order', to: 'payments#create_order'
      post 'payments/capture_payment', to: 'payments#capture_payment'
      post 'payments/verify_payment', to: 'payments#verify_payment'
      # post 'payments/webhook', to: 'payments#webhook'
      # get 'payments/checkout_iframe', to: 'payments#checkout_iframe'
    end
  end
end
