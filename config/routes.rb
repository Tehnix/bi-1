Rails.application.routes.draw do
  # JSON error responses
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#exception'

  get '/concerts', to: 'concerts#index'
  get '/concerts/:id', to: 'concerts#show'

  post '/concerts/:id', to: 'concerts#attend'
  delete '/concerts/:id', to: 'concerts#unattend'

  post '/concerts/:id/look_for_individual', to: 'concerts#look_for_individual'
  delete '/concerts/:id/look_for_individual', to: 'concerts#look_for_individual'
  post '/concerts/:id/look_for_group', to: 'concerts#look_for_group'
  delete '/concerts/:id/look_for_group', to: 'concerts#look_for_group'

  post '/concerts/:id/like/:profile_id', to: 'concerts#like'
  delete '/concerts/:id/like/:profile_id', to: 'concerts#like'

  resources :chats do
    resources :messages
  end

  # Authentication
  post '/auth', to: 'authentication#get_session_token'
end
