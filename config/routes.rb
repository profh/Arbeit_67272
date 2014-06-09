Arbeit4::Application.routes.draw do

  # Routes for main resources
  resources :domains
  resources :projects
  resources :tasks
  resources :assignments
  resources :users
  resources :sessions
  
  # Authentication routes
  get 'user/edit' => 'users#edit', as: :edit_current_user
  get 'signup' => 'users#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  patch 'completed/:id' => 'tasks#complete', as: :complete
  patch 'incomplete/:id' => 'tasks#incomplete', as: :incomplete
  patch 'toggle_task/:id' => 'tasks#toggle', as: :toggle
  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
