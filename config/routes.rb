Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "lunches#index"

  resources :employees
  resources :lunches, only: %i[index show]
end
