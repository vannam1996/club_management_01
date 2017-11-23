Rails.application.routes.draw do
  resources :tags
  root "static_pages#index"
  mount ActionCable.server => "/cable"

  mount Ckeditor::Engine => "/ckeditor"

  delete "join_event" => "user_events#destroy"
  get "other-clubs" => "clubs#index"

  get "/auth/:provider/callback", to: "omniauth_callbacks#create"
  get "/auth/failure", to: "omniauth_callbacks#failure"

  devise_for :users, controllers: {registrations: "registrations",
    sessions: "authentications", passwords: "passwords",
    omniauth_callbacks: "omniauth_callbacks"}
  devise_for :admin, controllers: {sessions: "admin/sessions"}

  devise_scope :admin do
    get "/admin/sign_in" => "admin/sessions#new", as: :new_admin_sessions
    delete "/admin/sign_out" => "admin/sessions#destroy", as: :destroy_admin_sessions
  end

  namespace :admin do
    get "/" => "static_pages#index"
    resources :users
    resources :organizations, except: [:edit, :update, :destroy]
    resources :feed_backs, only: :index
    resources :organization_requests
  end

  namespace :manager do
    get "/" => "static_pages#index"
    resources :requests
    resources :members
    resources :clubs
    resources :organizations
    resources :import_users, only: :create
    resources :request_members
  end

  namespace :club_manager do
    get "/" => "static_pages#index"
    resources :clubs do
      resources :members, only: [:index, :show]
      resources :club_budgets
      resources :events do
        resources :news
      end
      resources :albums do
        resources :images
      end
      resources :user_clubs
      resources :requests
    end
    resources :budgets
  end

  namespace :dashboard do
    get "/" => "static_pages#index"
    resources :requests
    resources :members
    resources :organizations
    resources :import_users, only: :create
    resources :request_members
    resources :clubs do
      resources :members, only: [:index, :show]
      resources :club_budgets
      resources :events do
        resources :news
      end
      resources :albums do
        resources :images
      end
      resources :user_clubs
      resources :requests
    end
    resources :budgets
    resources :export_history_budgets
    resources :club_export_members
    resources :request_clubs
  end

  resources :users do
    resources :club_requests, only: [:new, :create, :index]
    resources :organization_requests, only: [:new, :create, :index]
    resources :other_clubs, only: :index
    resources :feed_backs, only: [:new, :create]
    resources :user_organizations, except: [:new, :update]
  end

  resources :clubs, only: [:show, :index, :edit] do
    resources :events
    resources :albums do
      resources :images
    end
    resources :budgets
  end

  resources :invite_join_clubs, only: :create
  resources :messages
  resources :user_events, only: :create
  resources :ratings, only: :create
  resources :organizations do
    resources :clubs, only: [:show, :index]
  end
  resources :time_line_homes
  resources :time_line_homes
  resources :my_clubs
  resources :comments
  resources :set_language, only: :update
  resources :reason_leaves, only: [:index, :show, :create]
  resources :activities, only: :create
  resources :user_clubs
  resources :user_organizations, only: [:create, :destroy]
  resources :notifications
  resources :set_user_clubs
  resources :user_request_clubs
  resources :set_user_organizations
  resources :user_request_organizations
  resources :club_request_organizations

end
