Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :dogs
  post 'dog_like/:id', to: 'dogs#like', as: :dog_like
  delete 'dog_unlike/:id', to: 'dogs#unlike', as: :dog_unlike
  root to: "dogs#index"
end
