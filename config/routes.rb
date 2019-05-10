Rails.application.routes.draw do
  get '/service/:service_slug/user/:user_id', to: 'user_data#show'
  post '/service/:service_slug/user/:user_id', to: 'user_data#create_or_update'

  post '/service/:service_slug/savereturn/email/add', to: 'emails#create'
  post '/service/:service_slug/savereturn/email/confirm', to: 'emails#confirm'

  post '/service/:service_slug/savereturn/create', to: 'save_returns#create'
  delete '/service/:service_slug/savereturn/delete', to: 'save_returns#delete'

  post '/service/:service_slug/savereturn/signin/email', to: 'signins#email'
  post '/service/:service_slug/savereturn/signin/magiclink', to: 'signins#magic_link'
end
