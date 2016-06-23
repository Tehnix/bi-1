# Roskilde Festival +1

## Get session token

1. Send a post request to `/get_session_token` with the following JSON object
   ```javascript
   {
       'auth': {
           'profile_id': 'PROFILE_ID',
           'access_token': 'ACCESS_TOKEN'
       }
   }
   ```

2. Store the returned extended access- and session token
3. Add `Authorization: Token=SESSION_TOKEN` to future HTTP requests

## To do
- Users has a list of plus ones and plus 8s -> has_many :users, through: :plusses
- Concert has individual attendees and group attendees

## End-points

| Prefix            | Verb   | URI Pattern                                 | Controller#Action                |
|------------------:|--------|---------------------------------------------|----------------------------------|
|                   | GET    | /404(.:format)                              | errors#not_found                 |
|                   | GET    | /500(.:format)                              | errors#exception                 |
| concerts          | GET    | /concerts(.:format)                         | concerts#index                   |
|                   | GET    | /concerts/:id(.:format)                     | concerts#show                    |
|                   | POST   | /concerts/:id(.:format)                     | concerts#attend                  |
|                   | POST   | /concerts/:id/look_for_individual(.:format) | concerts#look_for_individual     |
|                   | POST   | /concerts/:id/look_for_group(.:format)      | concerts#look_for_group          |
| chat_messages     | GET    | /chats/:chat_id/messages(.:format)          | messages#index                   |
|                   | POST   | /chats/:chat_id/messages(.:format)          | messages#create                  |
| chat_message      | GET    | /chats/:chat_id/messages/:id(.:format)      | messages#show                    |
|                   | PATCH  | /chats/:chat_id/messages/:id(.:format)      | messages#update                  |
|                   | PUT    | /chats/:chat_id/messages/:id(.:format)      | messages#update                  |
|                   | DELETE | /chats/:chat_id/messages/:id(.:format)      | messages#destroy                 |
| chats             | GET    | /chats(.:format)                            | chats#index                      |
|                   | POST   | /chats(.:format)                            | chats#create                     |
| chat              | GET    | /chats/:id(.:format)                        | chats#show                       |
|                   | PATCH  | /chats/:id(.:format)                        | chats#update                     |
|                   | PUT    | /chats/:id(.:format)                        | chats#update                     |
|                   | DELETE | /chats/:id(.:format)                        | chats#destroy                    |
| get_session_token | POST   | /get_session_token(.:format)                | authentication#get_session_token |
