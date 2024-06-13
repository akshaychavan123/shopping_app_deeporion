Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      post 'auth/login', to: 'authentication#login'
      resources :orders, only: [:create]
    end
    namespace :v2 do
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :categories do
        resources :subcategories, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
