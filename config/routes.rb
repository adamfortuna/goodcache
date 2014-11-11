Rails.application.routes.draw do
  resources :users, only: [:show] do
    resources :books, only: [:index, :show], controller: 'user_books'
  end
end
