class Queries {
  static const String getCurrentUser = '''query getUser(\$f_Uid:String){
  users(where:{firebase_uid:{_eq:\$f_Uid}}){
    id
    name
    email
    email_verified
    profile_picture
    created_at
    updated_at
  }
} ''';

  static const String getUserChat =
      '''query getUserChat(\$user_id: String) @cached {
  assistant(where: {user_id: {_eq: \$user_id}}) {
    id
    user_id
    session_id
    messages
  }
} ''';

  static const String getUserList = '''query getUserList(\$user_id:String){
  users(where:{firebase_uid:{_neq:\$user_id}}){
    firebase_uid
    email
    name
    profile_picture
    
  }
} ''';

  static const String searchUsers =
      '''query searchUser(\$user_id: String,\$name:String) @cached {
  users(where: {firebase_uid: {_neq: \$user_id}, name: {_ilike: \$name}}) {
    firebase_uid
    email
    name
    profile_picture
  }
} ''';

  static const getCurrentChat = '''
subscription currentChat(\$current_user: String!, \$peer_user: String!) {
  chats(
    where: {
      _or: [
        { _and: [{ sent_user: { _eq: \$current_user } }, { recipient_user: { _eq: \$peer_user } }] }
        { _and: [{ sent_user: { _eq: \$peer_user } }, { recipient_user: { _eq: \$current_user } }] }
      ]
    }
  ) {
    id
    chat_room_id
    sent_user
    recipient_user
    messages
    is_active
  }
}
 ''';

  static const getChatRoomId = '''
query getSessionId(\$current_user:String,\$peer_user:String){
  chats(where:{sent_user:{_eq:\$current_user},recipient_user:{_eq:\$peer_user}}){
    chat_room_id
  }
}
 ''';

  static const getFcm = '''query getFcm(\$token:String){
  fcm_tokens(where:{token:{_eq:\$token}}){
    id
  }
} ''';

  static const getPeerUserToken = '''
query getFcm(\$user_id:String){
  fcm_tokens(where:{user_id:{_eq:\$user_id}},order_by:{updated_at:desc}){
  token
  }
}
 ''';
}
