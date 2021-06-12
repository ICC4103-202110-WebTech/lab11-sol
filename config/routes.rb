Rails.application.routes.draw do
  get 'search/search'
  root "pages#home"

  resources :breweries
  resources :brands
  resources :beers

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users do
        resources :reviews
      end
    end
  end

  resources :brands do
    resources :beers, shallow: true
  end

  resources :beers do
    resources :reviews, shallow: true
  end

  get "purge_watch_list", to: "beers#purge_wl"
  match 'search', to: "search#search", via: [:post, :get]

  devise_for :users
end
