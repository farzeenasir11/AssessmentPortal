Rails.application.routes.draw do
  get 'user_results/index'
  get 'user_results/show'
  devise_for :users, controllers: {
    registrations: 'registrations'}
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }
  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :projects do
    resources :assessments do
     member do
        get :attempt
        post :submit_attempt
        get 'assign_user'
        post 'assign_user'
     end
     resources :questions, only: [:new, :create]
     resources :users, only: [:index]
    end
    get 'users', to: 'users#index', as: 'project_users'
  end
  
  resources :user_projects, only: %i[index new create destroy]
  resources :user_assessments, only: %i[index show destroy]
  resources :user_results, only: %i[index show]
  root 'home#index'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
end
