Rails.application.routes.draw do
  resources :people, except: [:new, :edit]
end
