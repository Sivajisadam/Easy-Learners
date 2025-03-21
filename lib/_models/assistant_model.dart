class AiChat {
  String? aiResponse;
  String? userRequest;

  AiChat({this.aiResponse, this.userRequest});

  factory AiChat.fromJson(Map<String, dynamic> json) {
    return AiChat(
        aiResponse: json['aiResponse'], userRequest: json['userRequest']);
  }
}

class ChatList {
  String? id;
  String? userId;
  String? sessionId;
  List<AiChat>? aiChat;

  ChatList({this.id, this.userId, this.sessionId, this.aiChat});

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
        id: json['id'],
        userId: json['user_id'],
        sessionId: json['session_id'],
        aiChat:
            List<AiChat>.from(json['messages'].map((e) => AiChat.fromJson(e))));
  }
}
