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
  resources :multiple_load, only: [:new, :create]
  get 'cards_refresh/:id/' => 'game#get_cards', :via => :get
  get 'check_answer/:id' => 'game#check_answer', :via => :get
  get 'finish_test/:id' => 'game#finish_test', :via => :get

  resources :chat, only: [:index]
  resources :top, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
