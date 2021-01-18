Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :medical_procedures, only: %i[index create]
    end
  end
end
