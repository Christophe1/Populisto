QuestionnaireSite::Application.routes.draw do

  get "about_us", :to => "static_pages#about_us"
  get "contact_us", :to => "static_pages#contact_us"
  get "blog", :to => "static_pages#blog"
  get "competition_terms", :to => "static_pages#competition_terms"
  get "t_and_c", :to => "static_pages#terms_and_conditions"
  # get "log_in", :to => "users/sessions#new"
  # get "user", :to => @user(current_user)
  get "render_index_review", :to => "reviews#render_index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "sessions", :registrations => "registrations" }
  devise_scope :user do
    delete "sign_out", :to => "devise/sessions#destroy"
    get "login", :to => "devise/sessions#new"
  end


  devise_for :companies
  devise_scope :company do
    delete "sign_out", :to => "devise/sessions#destroy"
    get "login", :to => "devise/sessions#new"
  end

  devise_for :admins, :path => "admin", :controllers => { :sessions => "admin/sessions" }

  get "home/index"
  get "home/map", :as  => :map
  get ':id/address_book' => 'users#address_book', :as => :address_book
  get ':id/users_in_area' => 'users#users_in_area', :as => :users_in_area
  get ':id/friends_outside_area' => 'users#friends_outside_area', :as => :friends_outside_area
  post "home/update_address", :as  => :update_address
  match "canvas" => "canvas#index"
  match 'suggest_category' => 'reviews#suggest_category'
  get 'suggest_category_form' => 'reviews#suggest_category_form'

  match "/contacts/:importer/callback" => "email_invites#contacts_callback", :as => :contacts_callback
  match "/contacts/failure" => "email_invites#contacts_callback_failure", :as => :contacts_callback_failure
  mount Resque::Server, :at => "/resque"

  get "find" => 'search#index', :as => :find

  resources :search do
    collection do
      match :change_range
    end
  end

  resources :reviews do
    member do
      get :repost, :reject, :edit
      get :owner
    end
  end

  resources :companies

  resources :users do
    member do
      get :following_followers, :address_toggle
      get :follow
      get :unfollow
    end
  end
  resources :friend_relations, :only => [:create, :destroy]
  resources :email_invites do
    collection do
      get :confirm
      post :invitation_form
      post :outlook_import
    end
  end

  root :to => "home#index"

  namespace :admin do
    resource :profile, :only => [:edit, :update]

    resources :users do
      collection do
        get "map_view"
      end
    end
    resources :categories
    resources :reviews

    root :to => "users#index"
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'

  scope :constraint => {:slug => /[^\/]+/} do
    match ':slug' => 'users#show', :as => :resource_home
  end
end
