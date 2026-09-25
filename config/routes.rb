Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/login", to: "auth#login"
  post "/signup", to: "users#create"

  resources :posts, only: [ :create ] do
    # the route with collection looks like this: /posts/following
    collection do
      get :following
    end
  end
end
