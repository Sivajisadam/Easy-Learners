import 'package:easy_learners/view/utils/common_imports.dart';
import 'package:iconify_flutter_plus/icons/icon_park_solid.dart';

AppBar chatAppBar(RxString profilePicture, RxString name,
    {Function()? onClearChat, Function()? onBlockUser}) {
  return AppBar(
    forceMaterialTransparency: true,
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
            giveText: name.value, fontsize: 24, fontweight: FontWeight.w600),
        Row(
          children: [
            Icon(Icons.circle, color: Colors.green, size: 12),
            hSpace(4),
            reusableText(
                giveText: "Active", fontsize: 14, fontweight: FontWeight.w600),
          ],
        ),
      ],
    ),
    actions: [
      PopupMenuButton<String>(
        position: PopupMenuPosition.under,
        menuPadding: EdgeInsets.symmetric(horizontal: 16),
        icon: Icon(Icons.more_vert, size: 24),
        onSelected: (value) {
          if (value == 'clear_chat') {
            onClearChat!();
          } else if (value == 'block_user') {
            onBlockUser!();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'clear_chat',
            child: Row(
              children: [
                Icon(Icons.delete_sweep, color: ColorConstants.primaryColor),
                hSpace(8),
                reusableText(giveText: 'Clear Chat', fontsize: 16),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'block_user',
            child: Row(
              children: [
                Icon(Icons.block, color: Colors.red),
                hSpace(8),
                reusableText(giveText: 'Block User', fontsize: 16),
              ],
            ),
          ),
        ],
      ),
      hSpace(16)
    ],
  );
}

Padding messageField(ChatController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: textField(
        fieldController: controller.chatController,
        contentPadding: const EdgeInsets.all(20),
        giveHint: "Type a message...",
        borderRadius: 50,
        fieldMaxLines: null,
        suffixWidget: GestureDetector(
          onTap: () {
            controller.sendMessage();
          },
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

Align chatBubble(bool isCurrentUserMessage, Messages? message) {
  return Align(
    alignment: isCurrentUserMessage ? Alignment.topRight : Alignment.topLeft,
    child: reuseContainer(
      maxWidth: Get.width * 0.7,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 5),
      decoration: BoxDecoration(
        color: isCurrentUserMessage ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          topLeft: isCurrentUserMessage ? Radius.circular(15) : Radius.zero,
          topRight: isCurrentUserMessage ? Radius.zero : Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            crossAxisAlignment: isCurrentUserMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              reusableText(
                  giveText: message?.message ?? "",
                  fontsize: 16,
                  textColor: ColorConstants.primaryColor,
                  maxLine: 5),
              vSpace(20)
            ],
          ),
          reusableText(
              giveText: DateFormat("hh:mm a")
                  .format(DateTime.parse(message?.sentAt.toString() ?? "")),
              textColor: ColorConstants.secondaryText)
        ],
      ),
    ),
  );
}

Padding dateWidget(ChatController controller, Messages? message) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: reusableText(
          giveText: controller
              .getFormattedDateHeader(message?.sentAt.toString() ?? ""),
          fontsize: 14,
          textColor: Colors.grey.shade700,
        ),
      ),
    ),
  );
}
