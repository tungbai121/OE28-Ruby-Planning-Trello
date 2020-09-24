Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"

    get "/register", to: "registers#new", as: "register"
    post "/register", to: "registers#create"

    resources :users, only: %i(show edit update)
    resources :boards do
      resource :tags, only: :create, as: "create_tag"
    end

    patch "/status", to: "boards#update_board_status", as: "status"
    patch "/close", to: "boards#update_board_closed", as: "board_closed"
    resources :labels, only: %i(create update destroy)
  end
end
