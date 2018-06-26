Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :tests
      resources :test_results
      resources :cards

      root to: "users#index"
    end
  devise_for :users
  root "game#index"
  resources :game, only: [:index, :show, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
