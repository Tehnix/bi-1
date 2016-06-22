## End-points

| Prefix            | Verb   | URI Pattern                            | Controller#Action                |
|------------------:|--------|----------------------------------------|----------------------------------|
|                   | GET    | /404(.:format)                         | errors#not_found                 |
|                   | GET    | /500(.:format)                         | errors#exception                 |
| concerts          | GET    | /concerts(.:format)                    | concerts#index                   |
|                   | GET    | /concerts/:id(.:format)                | concerts#show                    |
|                   | POST   | /concerts/:id(.:format)                | concerts#attend                  |
| chat_messages     | GET    | /chats/:chat_id/messages(.:format)     | messages#index                   |
|                   | POST   | /chats/:chat_id/messages(.:format)     | messages#create                  |
| chat_message      | GET    | /chats/:chat_id/messages/:id(.:format) | messages#show                    |
|                   | PATCH  | /chats/:chat_id/messages/:id(.:format) | messages#update                  |
|                   | PUT    | /chats/:chat_id/messages/:id(.:format) | messages#update                  |
|                   | DELETE | /chats/:chat_id/messages/:id(.:format) | messages#destroy                 |
| chats             | GET    | /chats(.:format)                       | chats#index                      |
|                   | POST   | /chats(.:format)                       | chats#create                     |
| chat              | GET    | /chats/:id(.:format)                   | chats#show                       |
|                   | PATCH  | /chats/:id(.:format)                   | chats#update                     |
|                   | PUT    | /chats/:id(.:format)                   | chats#update                     |
|                   | DELETE | /chats/:id(.:format)                   | chats#destroy                    |
| get_session_token | POST   | /get_session_token(.:format)           | authentication#get_session_token |
