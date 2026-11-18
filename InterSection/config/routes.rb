Rails.application.routes.draw do
  root "properties#index"
  resources :properties, only: %i[index show] do
    resources :city_gems, only: :show
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :tags, :categories, :properties, :neighbourhoods, :property_neighbourhoods, :city_gems,
                only: %i[index show create update destroy]
    end
  end
end
