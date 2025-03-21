import 'package:easy_learners/view/chats/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:easy_learners/view/utils/common_imports.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardVisibilityController = KeyboardVisibilityController();
      keyboardVisibilityController.onChange.listen((bool visible) {
        if (visible) {
          controller.scrollToBottom();
        }
      });
    });

    return Scaffold(
      appBar: chatAppBar(profilePicture, name),
      body: Column(
        children: [
          Expanded(
            child: GraphQLProvider(
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
                        child:
                            Text(result.exception!.graphqlErrors.toString()));
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
                    controller.sortChatMessages();

                    // Scroll to bottom when messages are loaded
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.scrollToBottom();
                    });
                  }

                  return ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.userChat.messages?.length,
                      itemBuilder: (context, index) {
                        final message = controller.userChat.messages?[index];
                        final isCurrentUserMessage = message?.messageBy ==
                            FirebaseAuth.instance.currentUser!.uid;

                        return Column(
                          children: [
                            if (controller.showDateHeader(index))
                              dateWidget(controller, message),
                            chatBubble(isCurrentUserMessage, message)
                          ],
                        );
                      });
                },
              ),
            ),
          ),
          messageField(controller),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

// Add this class for keyboard visibility detection
class KeyboardVisibilityController {
  // This is a simplified version - in a real app you might want to use a package
  Stream<bool> get onChange =>
      Stream.periodic(const Duration(milliseconds: 100))
          .map((_) => MediaQuery.of(Get.context!).viewInsets.bottom > 0);
}
