Rails.application.routes.draw do
  resources :tasks
  # get 'tasks/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "tasks#index"
end
