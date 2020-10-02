Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"

    get "/register", to: "registers#new", as: "register"
    post "/register", to: "registers#create"

    resources :users, only: %i(show edit update) do
      get "/closed", to: "users#closed", as: "closed"
    end
    resources :boards do
      resource :tags, only: :create, as: "create_tag"
      resource :tag_labels, only: %i(create destroy)
      post "labels/create", to: "labels#create", as: "create_label"
      patch "labels/:id", to: "labels#update", as: "update_label"
      delete "labels/:id", to: "labels#destroy", as: "destroy_label"
      patch "tags/sort", to: "tags#sort", as: "sort_tag"
    end

    patch "/status", to: "boards#update_board_status", as: "status"
    patch "/close", to: "boards#update_board_closed", as: "board_closed"
    resources :lists, only: %i(create update destroy)
    resources :add_members, only: %i(new edit)
    patch "list/changeposition", to: "lists#change_position", as: "position_list"
    patch "list/closed", to: "lists#closed_list", as: "closed_list"

    match "*unmatched", to: "application#rescue_404_exception", via: :all
  end
end
