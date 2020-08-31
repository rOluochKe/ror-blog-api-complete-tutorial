Rails.application.routes.draw do
  post 'login', to: 'access_tokens#create'
  resources :articles, only: [:new, :show]
end
