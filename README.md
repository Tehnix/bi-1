# Roskilde Festival +1

## Get session token

1. Send a POST request to `/auth` with the following JSON object
   ```javascript
   {
       'auth': {
           'profile_id': 'PROFILE_ID',
           'access_token': 'ACCESS_TOKEN'
       }
   }
   ```

2. Store the returned extended access- and session token
3. Add `Authorization: Token token=SESSION_TOKEN` to future HTTP requests

## End-points
|        Prefix | Verb   | URI Pattern                                 | Controller#Action                |
| ------------: | ------ | ------------------------------------------- | -------------------------------- |
|               | GET    | /404(.:format)                              | errors#not_found                 |
|               | GET    | /500(.:format)                              | errors#exception                 |
|      concerts | GET    | /concerts(.:format)                         | concerts#index                   |
|               | GET    | /concerts/:id(.:format)                     | concerts#show                    |
|               | POST   | /concerts/:id(.:format)                     | concerts#attend                  |
|               | DELETE | /concerts/:id(.:format)                     | concerts#unattend                |
|               | POST   | /concerts/:id/look_for_individual(.:format) | concerts#look_for_individual     |
|               | DELETE | /concerts/:id/look_for_individual(.:format) | concerts#unlook_for_individual   |
|               | POST   | /concerts/:id/look_for_group(.:format)      | concerts#look_for_group          |
|               | DELETE | /concerts/:id/look_for_group(.:format)      | concerts#unlook_for_group        |
|               | POST   | /concerts/:id/like/:profile_id(.:format)    | concerts#like                    |
|               | DELETE | /concerts/:id/like/:profile_id(.:format)    | concerts#unlike                  |
| chat_messages | GET    | /chats/:chat_id/messages(.:format)          | messages#index                   |
|               | POST   | /chats/:chat_id/messages(.:format)          | messages#create                  |
|  chat_message | GET    | /chats/:chat_id/messages/:id(.:format)      | messages#show                    |
|               | PATCH  | /chats/:chat_id/messages/:id(.:format)      | messages#update                  |
|               | PUT    | /chats/:chat_id/messages/:id(.:format)      | messages#update                  |
|               | DELETE | /chats/:chat_id/messages/:id(.:format)      | messages#destroy                 |
|         chats | GET    | /chats(.:format)                            | chats#index                      |
|               | POST   | /chats(.:format)                            | chats#create                     |
|          chat | GET    | /chats/:id(.:format)                        | chats#show                       |
|               | PATCH  | /chats/:id(.:format)                        | chats#update                     |
|               | PUT    | /chats/:id(.:format)                        | chats#update                     |
|               | DELETE | /chats/:id(.:format)                        | chats#destroy                    |
|          auth | POST   | /auth(.:format)                             | authentication#get_session_token |
