Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"

    get "/register", to: "registers#new", as: "register"
    post "/register", to: "registers#create"

    resources :users, only: :show
    resources :boards
  end
end
