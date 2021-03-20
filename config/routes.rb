Rails.application.routes.draw do
  get 'page/index'
  resources :js_log, only: [:create]

  namespace :admin do
      resources :users
      resources :tests
      resources :test_results
      resources :cards
      resources :languages
      resources :pages
      resources :groups

      root to: "users#index"
    end
  devise_for :users
  root "game#index"
  get 'premium', to: 'game#premium', as: :game_premium
  resources :game, only: [:index, :show]
  resources :multiple_load, only: [:new, :create]
  resources :reset_repeats, only: [:update]

  get 'cards_set/:id/' => 'game#cards_set', :via => :get
  get 'check_answer/:id' => 'game#check_answer', :via => :get
  get 'finish_test/:id' => 'game#finish_test', :via => :get

  post 'selected_cards/select', as: :select_card
  delete 'selected_cards/unselect_all', as: :unselect_all_cards

  resources :personal_account, only: [:index]
  resources :language, only: :update

  get '/:url', to: 'page#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
