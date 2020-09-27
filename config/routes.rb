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

      post "labels/create", to: "labels#create", as: "create_label"
      patch "labels/:id", to: "labels#update", as: "update_label"
      delete "labels/:id", to: "labels#destroy", as: "destroy_label"
    end

    patch "/status", to: "boards#update_board_status", as: "status"
    patch "/close", to: "boards#update_board_closed", as: "board_closed"
    resource :lists, only: :create
    resources :add_members, only: %i(new edit)
  end
end
