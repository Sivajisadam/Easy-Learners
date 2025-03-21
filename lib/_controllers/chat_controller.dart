import 'package:easy_learners/_controllers/services_controller.dart';
import 'package:easy_learners/_models/user_chat_model.dart';
import 'package:easy_learners/view/utils/mutation_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find<ChatController>();
  TextEditingController chatController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  UserChat userChat = UserChat(messages: <Messages>[]);

  final ScrollController scrollController = ScrollController();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  startChatSession() {
    final chatSessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final messageText = chatController.text.trim();
    final messages = [
      {
        "message_by": auth.currentUser!.uid,
        "message": messageText,
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
    });

    Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
  }

  updateChatSession() {
    final messageText = chatController.text.trim();
    userChat.messages!.insert(
        userChat.messages!.length - 1,
        Messages(
          message: messageText,
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

    Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
  }

  sendMessage() {
    if (chatController.text.trim().isEmpty) return;

    if (userChat.id == null) {
      startChatSession();
    } else {
      updateChatSession();
    }
  }

  sortChatMessages() {
    userChat.messages?.sort((a, b) => DateFormat("dd MM yyyy HH:mm:ss a")
        .format(DateTime.parse(a.sentAt.toString()))
        .compareTo(DateFormat("dd MM yyyy HH:mm:ss a")
            .format(DateTime.parse(b.sentAt.toString()))));
  }

  bool showDateHeader(int index) {
    if (userChat.messages == null ||
        userChat.messages!.isEmpty ||
        index < 0 ||
        index >= userChat.messages!.length) {
      return false;
    }

    if (index == 0) {
      return true;
    }

    final currentMessageDate = DateFormat("dd MM yyyy")
        .format(DateTime.parse(userChat.messages![index].sentAt.toString()));

    final previousMessageDate = DateFormat("dd MM yyyy").format(
        DateTime.parse(userChat.messages![index - 1].sentAt.toString()));

    return currentMessageDate != previousMessageDate;
  }

  String getFormattedDateHeader(String dateString) {
    final messageDate = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay =
        DateTime(messageDate.year, messageDate.month, messageDate.day);

    if (messageDay == today) {
      return "Today";
    } else if (messageDay == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat("dd MMM yyyy").format(messageDate);
    }
  }
}
