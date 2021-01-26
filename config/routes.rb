Rails.application.routes.draw do
  resources :players, only: :new do
    collection { post "create_game" }
  end

  resources :games, param: :join_code, only: :show do
    member do
      resources :players, only: [:create, :destroy]
      post "start"
    end
  end

  root to: "players#new"
end
