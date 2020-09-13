Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :locations, only: :show
  resources :users, only: :show

  root to: "locations#index"
end
