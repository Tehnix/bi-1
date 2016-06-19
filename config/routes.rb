Rails.application.routes.draw do
  resources :concerts
  resources :chats
  post '/get_session_token', to: 'authentication#get_session_token'
end
