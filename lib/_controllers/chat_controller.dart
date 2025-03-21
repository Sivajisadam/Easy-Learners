import 'package:easy_learners/_controllers/services_controller.dart';
import 'package:easy_learners/_models/user_chat_model.dart';
import 'package:easy_learners/view/utils/mutation_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find<ChatController>();
  TextEditingController chatController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  UserChat userChat = UserChat(messages: <Messages>[]);

  startChatSession() {
    final chatSessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final messages = [
      {
        "message_by": auth.currentUser!.uid,
        "message": chatController.text.trim(),
        "sent_at": DateTime.now().toIso8601String(),
      }
    ];
    chatController.clear();

    ServiceController.to
        .graphqlMutation(ConstantMutationQuaries.insertOne("chats"), {
      "object": {
        "chat_room_id": chatSessionId,
        "sent_user": auth.currentUser!.uid,
        "recipient_user": Get.arguments["user_id"],
        "messages": messages,
      }
    }).then((v) {
      printInfo(info: v.toString());
    });
  }

  updateChatSession() {
    userChat.messages!.insert(
        userChat.messages!.length - 1,
        Messages(
          message: chatController.text.trim(),
          messageBy: auth.currentUser!.uid,
          sentAt: DateTime.now().toIso8601String(),
        ));
    final messages = userChat.messages?.map((e) {
      return {
        "message_by": e.messageBy,
        "message": e.message,
        "sent_at": e.sentAt,
      };
    }).toList();
    chatController.clear();
    ServiceController.to
        .graphqlMutation(ConstantMutationQuaries.updateOne("chats"), {
      "id": userChat.id,
      "object": {
        "chat_room_id": userChat.chatRoomId,
        "messages": messages,
      }
    });
  }

  sendMessage() {}
}
