Rails.application.routes.draw do

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#exception'

  resources :concerts
  resources :chats
  post '/get_session_token', to: 'authentication#get_session_token'
end
