import 'package:easy_learners/_controllers/chat_controller.dart';
import 'package:easy_learners/_models/user_chat_model.dart';
import 'package:easy_learners/graphql_client.dart';
import 'package:easy_learners/view/utils/constants.dart';
import 'package:easy_learners/view/utils/queries.dart';
import 'package:easy_learners/view/utils/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/icon_park_solid.dart';
import 'package:intl/intl.dart';

class ChatDetails extends HookWidget {
  const ChatDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    RxString name = ''.obs;
    RxString profilePicture = ''.obs;
    if (Get.arguments != null) {
      name(Get.arguments["name"]);
      profilePicture(Get.arguments["profilePicture"]);
    }
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(profilePicture.value),
          ),
        ),
        titleSpacing: 8,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reusableText(
                giveText: name.value,
                fontsize: 24,
                fontweight: FontWeight.w600),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                hSpace(4),
                reusableText(
                    giveText: "Active",
                    fontsize: 14,
                    fontweight: FontWeight.w600),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: textField(
            fieldController: controller.chatController,
            contentPadding: const EdgeInsets.all(20),
            giveHint: "Type a message...",
            borderRadius: 50,
            fieldMaxLines: null,
            suffixWidget: GestureDetector(
              onTap: () {
                controller.userChat.chatRoomId == null
                    ? controller.startChatSession()
                    : controller.updateChatSession();
              },
              child: const Iconify(
                IconParkSolid.voice_one,
                size: 24,
              ),
            ),
            onFieldEntry: (v) {},
            onFieldSubmitted: (v) {
              controller.userChat.chatRoomId == null
                  ? controller.startChatSession()
                  : controller.updateChatSession();
            }),
      ),
      body: GraphQLProvider(
        client: ValueNotifier(useClient(context)),
        child: Subscription(
          options: SubscriptionOptions(
              document: gql(Queries.getCurrentChat),
              variables: {
                "current_user": FirebaseAuth.instance.currentUser!.uid,
                "peer_user": Get.arguments["user_id"],
              }),
          builder: (result) {
            if (result.hasException) {
              return Center(
                  child: Text(result.exception!.graphqlErrors.toString()));
            }
            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (result.data == null) {
              return Container();
            }
            if (result.data!['chats'].isNotEmpty) {
              var d = result.data?['chats'][0];
              controller.userChat = UserChat.fromJson(d);
              controller.userChat.messages?.sort((a, b) =>
                  DateFormat("dd MM yyyy HH:mm:ss a")
                      .format(DateTime.parse(a.sentAt.toString()))
                      .compareTo(DateFormat("dd MM yyyy HH:mm:ss a")
                          .format(DateTime.parse(b.sentAt.toString()))));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.userChat.messages?.length,
                      itemBuilder: (context, index) {
                        final message = controller.userChat.messages?[index];
                        final isCurrentUserMessage = message?.messageBy ==
                            FirebaseAuth.instance.currentUser!.uid;

                        return Column(
                          children: [
                            Align(
                              alignment: isCurrentUserMessage
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: reuseContainer(
                                maxWidth: Get.width * 0.7,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isCurrentUserMessage
                                      ? Colors.blue[200]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topLeft: isCurrentUserMessage
                                        ? Radius.circular(15)
                                        : Radius.zero,
                                    topRight: isCurrentUserMessage
                                        ? Radius.zero
                                        : Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: isCurrentUserMessage
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    reusableText(
                                      giveText: message?.message ?? "",
                                      fontsize: 16,
                                      textColor: ColorConstants.primaryColor,
                                    ),
                                    reusableText(
                                        giveText: DateFormat("hh:mm a").format(
                                            DateTime.parse(
                                                message?.sentAt.toString() ??
                                                    "")))
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
