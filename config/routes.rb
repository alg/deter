Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'user_sessions#new'

  get '/news' => 'pages#news', as: 'news'
  get '/usage' => 'pages#usage', as: 'usage'

  resources :applications
  resources :user_sessions, only: [ :new, :create, :destroy ]

  resources :password_reset_requests, only: [ :new, :create ]
  get  '/password_reset' => 'password_resets#new', as: 'new_password_reset'
  get  '/password_reset/:challenge' => 'password_resets#new'
  post '/password_reset' => 'password_resets#create', as: 'password_reset'

  get '/login' => 'user_sessions#new', as: 'login'
  get '/logout' => 'user_sessions#destroy', as: 'logout'
  get '/dashboard' => 'dashboard#show', as: 'dashboard'

  get  '/profile' => 'profile#show', as: 'profile'
  get  '/profile/edit' => 'profile#edit', as: 'edit_profile'
  post '/profile/edit' => 'profile#update'
  get  '/password/change' => 'password#edit', as: 'change_password'
  post '/password/change' => 'password#update'

  resources :projects, only: [ :index, :new, :create, :destroy, :show ] do
    member do
      get :profile
      get :manage
      get :details
    end
  end
  resources :project_joins, only: [ :new, :create ]
  resources :circles,     only: [ :index, :new, :create, :destroy ]
  resources :experiments, only: [ :index, :new, :create, :destroy, :show ] do
    member do
      get :profile
      post :run
      get :manage
    end
  end

  resources :users, only: [ :show ]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
