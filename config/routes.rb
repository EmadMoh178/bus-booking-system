Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post 'signup', to: 'users#create'
  post 'login', to: 'authentication#login'
  # Defines the root path route ("/")
  # root "posts#index"

  resources :bookings, only: [] do
    collection do
      get 'available_seats'
      post 'book_seat'
    end
  end
end