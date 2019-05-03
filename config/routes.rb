Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/service/:service_slug/user/:user_id', to: 'user_data#show'
  post '/service/:service_slug/user/:user_id', to: 'user_data#create_or_update'

  post '/service/:service_slug/savereturn/email/add', to: 'emails#create'
  post '/service/:service_slug/savereturn/email/confirm', to: 'emails#confirm'

  post '/service/:service_slug/savereturn/create', to: 'save_returns#create'

  get '/service/:service_slug/savereturn/signin/email/:email', to: 'signins#email'
end
