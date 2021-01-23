Rails.application.routes.draw do
  resources :players, only: [:new, :create]
  resources :games, param: :join_code, only: :show do
    member do
      post "start"
    end
  end

  root to: "players#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
