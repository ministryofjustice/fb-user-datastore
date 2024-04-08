Rails.application.routes.draw do
  get '/health', to: 'health#show'
  get '/readiness', to: 'health#readiness'

  get '/service/:service_slug/user/:user_id', to: 'user_data#show'
  post '/service/:service_slug/user/:user_id', to: 'user_data#create_or_update'

  get '/service/:service_slug/saved/:uuid', to: 'save_and_return#show'
  post '/service/:service_slug/saved', to: 'save_and_return#create'
  post '/service/:service_slug/saved/:uuid/increment', to: 'save_and_return#increment'
  post '/service/:service_slug/saved/:uuid/invalidate', to: 'save_and_return#invalidate'
end
