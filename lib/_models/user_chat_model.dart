class UserChat {
  String? id;
  String? chatRoomId;
  String? sentUser;
  String? recipientUser;
  List<Messages>? messages;
  bool? isActive;

  UserChat(
      {this.id,
      this.chatRoomId,
      this.sentUser,
      this.recipientUser,
      this.messages,
      this.isActive});

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(
        id: json['id'],
        chatRoomId: json['chat_room_id'],
        sentUser: json['sent_user'],
        recipientUser: json['recipient_user'],
        messages: List<Messages>.from(
            json['messages'].map((e) => Messages.fromJson(e))),
        isActive: json['is_active']);
  }
}

class Messages {
  String? messageBy;
  String? message;
  String? sentAt;

  Messages({this.message, this.messageBy, this.sentAt});

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      message: json['message'],
      messageBy: json['message_by'],
      sentAt: json['sent_at'],
    );
  }
}
