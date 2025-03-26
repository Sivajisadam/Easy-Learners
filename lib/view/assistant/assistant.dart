import 'package:easy_learners/view/assistant/widgets.dart';
import 'package:easy_learners/view/utils/common_imports.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  AssistantScreenState createState() => AssistantScreenState();
}

class AssistantScreenState extends State<AssistantScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();
    return Scaffold(
      onEndDrawerChanged: (v) {
        if (v == true && controller.totalChat.isEmpty) {
          controller.getChatHistory();
        } else {
          final history = HiveStorage.getData(
              boxName: HiveStorage.assistantBox, key: "chatHistory");
          printInfo(info: history.length.toString());
        }
      },
      endDrawer: chatHistoryWidget(controller),
      appBar: assistantAppBar(controller),
      bottomNavigationBar: assistantField(controller),
      body: GetBuilder<BottomNavController>(
        builder: (controller) {
          final chatList = controller.chatHistory.aiChat ?? [];
          return Column(
            children: [
              assistantChatList(controller, chatList),
            ],
          );
        },
      ),
    );
  }
}
