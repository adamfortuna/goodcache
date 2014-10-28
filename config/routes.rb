Rails.application.routes.draw do
  resources :users, only: [] do
    resources :books, only: [:index, :show], controller: 'user_books'
  end
end
