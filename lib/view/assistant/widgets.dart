import 'package:iconify_flutter_plus/icons/gg.dart';
import 'package:iconify_flutter_plus/icons/icon_park_solid.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';

import '../utils/common_imports.dart';

Expanded assistantChatList(
    BottomNavController controller, List<AiChat> chatList) {
  return Expanded(
    child: ListView.builder(
      padding: const EdgeInsets.all(10),
      controller: controller.scrollController,
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        final chat = chatList[index];
        final isLastMessage = index == chatList.length - 1;

        return Column(
          children: [
            if (chat.userRequest != null && chat.userRequest!.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: reuseContainer(
                  maxWidth: Get.width * 0.7,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    chat.userRequest!.capitalizeFirst.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            if (isLastMessage && controller.isStreaming.value)
              StreamBuilder<String>(
                stream: controller.streamResponse.stream,
                builder: (context, snapshot) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: reuseContainer(
                      maxWidth: Get.width * 0.85,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: reuseMarkdownText(
                        message: snapshot.data ?? "...",
                      ),
                    ),
                  );
                },
              )
            else if (chat.aiResponse != null && chat.aiResponse!.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: reuseContainer(
                  maxWidth: Get.width * 0.85,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: reuseMarkdownText(message: chat.aiResponse!),
                ),
              ),
          ],
        );
      },
    ),
  );
}

Padding assistantField(BottomNavController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: textField(
        fieldController: controller.promtController.value,
        contentPadding: const EdgeInsets.all(20),
        giveHint: "Type a message...",
        borderRadius: 50,
        fieldMaxLines: null,
        suffixWidget: GestureDetector(
          onTap: controller.sendMessage,
          child: const Iconify(
            IconParkSolid.voice_one,
            size: 24,
          ),
        ),
        onFieldEntry: (v) {},
        onFieldSubmitted: (v) {
          controller.sendMessage();
        }),
  );
}

AppBar assistantAppBar(BottomNavController controller) {
  return AppBar(
    leading: GestureDetector(
      onTap: controller.clearcurrentChat,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Iconify(
          MaterialSymbols.edit_square_outline_rounded,
        ),
      ),
    ),
    title: const Text('AI Chat Assistant'),
    centerTitle: true,
    actions: [
      // Icon(Icons.menu_open_rounded),
      Builder(
        builder: (context) => IconButton(
          icon: Iconify(Gg.menu_right), // Use your preferred icon here
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ),
    ],
  );
}

Drawer chatHistoryWidget(BottomNavController controller) {
  return Drawer(
    child: Obx(
      () => SafeArea(
        child: Column(
          children: [
            vSpace(20),
            reusableText(
                giveText: "Your Activity",
                fontsize: 30,
                fontweight: FontWeight.w500),
            Divider(
              color: ColorConstants.primaryColor,
              thickness: 1,
              endIndent: 20,
              indent: 20,
            ),
            vSpace(10),
            ListView.separated(
              separatorBuilder: (context, index) => vSpace(8),
              itemCount: controller.totalChat.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.back();
                    controller.chatList = controller.totalChat[index];
                    controller.update();
                  },
                  child: reuseContainer(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    giveColor: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                    child: reusableText(
                        giveText: controller
                                .totalChat[index].aiChat?.first.userRequest
                                .toString()
                                .capitalizeFirst ??
                            "",
                        fontsize: 18,
                        fontweight: FontWeight.w400),
                  ),
                );
              },
            )
          ],
        ),
      ),
    ),
  );
}
