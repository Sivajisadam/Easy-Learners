class AiChat {
  String? aiResponse;
  String? userRequest;

  AiChat({this.aiResponse, this.userRequest});

  factory AiChat.fromJson(Map<String, dynamic> json) {
    return AiChat(
        aiResponse: json['aiResponse'], userRequest: json['userRequest']);
  }
}

class ChatHistory {
  String? id;
  String? userId;
  String? sessionId;
  List<AiChat>? aiChat;

  ChatHistory({this.id, this.userId, this.sessionId, this.aiChat});

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
        id: json['id'],
        userId: json['user_id'],
        sessionId: json['session_id'],
        aiChat:
            List<AiChat>.from(json['messages'].map((e) => AiChat.fromJson(e))));
  }
}
