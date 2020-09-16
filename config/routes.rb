Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"

    resources :boards
  end
end
