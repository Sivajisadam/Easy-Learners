import 'package:easy_learners/view/utils/common_imports.dart';

class ChatScreen extends GetWidget<BottomNavController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.userList.isEmpty ? controller.getUserList() : null;
    controller.update();
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reusableText(
                    giveText: "Chats",
                    fontsize: 30,
                    fontweight: FontWeight.w600),
                vSpace(30),
                textField(
                  fieldController: controller.userSearch.value,
                  giveHint: "Search User",
                  borderColor: Colors.grey.shade300,
                  onFieldEntry: (v) {
                    controller.debounce(() {
                      controller.searchUser(v);
                    }, duration: const Duration(milliseconds: 500));
                  },
                ),
                vSpace(20),
                ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () =>
                            Get.toNamed(Routes.chatDetails, arguments: {
                          "user_id": controller.userList[index].userId,
                          "name": controller.userList[index].name,
                          "profilePicture": controller
                                  .userList[index].profilePicture
                                  .toString()
                                  .isNotEmpty
                              ? controller.userList[index].profilePicture
                                  .toString()
                              : "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg",
                        }),
                        child: ListTile(
                          tileColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(controller
                                    .userList[index].profilePicture
                                    .toString()
                                    .isNotEmpty
                                ? controller.userList[index].profilePicture
                                    .toString()
                                : "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg"),
                          ),
                          title: Text(controller.userList[index].name ?? ""),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => vSpace(8),
                    itemCount: controller.userList.length)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
