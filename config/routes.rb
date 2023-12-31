Rails.application.routes.draw do
  get '/bookings', to: 'bookings#index'
  get '/user-bookings', to: 'bookings#user_bookings', as: 'user_bookings'
  delete "/booking/:id", to: 'bookings#destroy', as:'delete_booking'
  devise_for :users
  resources :events do
    resources :bookings, only: [:create]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "events#index"
end
