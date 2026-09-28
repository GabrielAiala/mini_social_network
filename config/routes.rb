Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/login", to: "auth#login"
  post "/signup", to: "users#create"

  resources :users, only: [ :index, :show ]

  resources :likes, only: [ :create ]

  resources :posts, only: [ :create ] do
    # the route with collection looks like this: /posts/following
    collection do
      get :following
    end
    # the route with member looks like this: /posts/:id/by_user
    member do
      get :by_user, to: "posts#posts_by_user"
    end
  end
end
