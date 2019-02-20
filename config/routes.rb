Rails.application.routes.draw do
  resources :secrets

  # We want to "preview" the secret after saving, since showing will delete
  # it from the DB.
  get 'preview', to: 'secrets#preview'#, as: :completed_tasks

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
