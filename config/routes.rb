Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      
      resources :books, only: [:index, :create, :destroy]
      get 'books/:id', to: 'books#show'
      post 'auth', to: 'auth#create'
    end
  end
end
