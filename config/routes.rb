Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"

    get "/register", to: "registers#new", as: "register"
    post "/register", to: "registers#create"

    resources :users, only: %i(show edit update) do
      resources :activities, only: :index
      resources :closed, only: :index
    end
    resources :boards do
      resource :tag_labels, only: %i(create edit destroy)
      post "labels/create", to: "labels#create", as: "create_label"
      patch "labels/:id", to: "labels#update", as: "update_label"
      delete "labels/:id", to: "labels#destroy", as: "destroy_label"

      resources :tags, except: %i(index show new) do
        resources :checklists, only: %i(create update destroy)
        resource :deadline, only: %i(create update destroy)

        post "/join", on: :member, to: "join_tags#create"
        delete "/leave", on: :member, to: "join_tags#destroy"

        post "/close", on: :member, to: "close_tags#create"
        delete "/open", on: :member, to: "close_tags#destroy"

        resources :attachments, only: :create
      end
      patch "sort/tags", to: "sortable_tags#update", as: "sort_tags"

      resource :tag_users, only: %i(create edit destroy)
      resources :user_boards, only: :update
    end

    patch "/status", to: "boards#update_board_status", as: "status"
    patch "/close", to: "boards#update_board_closed", as: "board_closed"
    resources :lists, only: %i(create update destroy)
    resources :add_members, only: %i(new edit)
    patch "list/changeposition", to: "lists#change_position", as: "position_list"
    patch "list/closed", to: "lists#closed_list", as: "closed_list"

    resources :search, only: :index

    match "*unmatched", to: "application#rescue_404_exception", via: :all
  end
end
