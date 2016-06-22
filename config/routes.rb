Rails.application.routes.draw do
  # JSON error responses
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#exception'

  get '/concerts', to: 'concerts#index'
  get '/concerts/:id', to: 'concerts#show'
  post '/concerts/:id', to: 'concerts#attend'

  resources :chats do
    resources :messages
  end

  # Authentication
  post '/get_session_token', to: 'authentication#get_session_token'
end
