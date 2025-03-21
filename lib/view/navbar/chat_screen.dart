import 'package:easy_learners/_controllers/bottom_nav_controller.dart';
import 'package:easy_learners/view/utils/reusable_widget.dart';
import 'package:easy_learners/view/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends GetWidget<BottomNavController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.chatList.aiChat == null ? controller.getUserList() : null;
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
                    fieldController: TextEditingController(),
                    giveHint: "Search User",
                    borderColor: Colors.grey.shade300,
                    onFieldEntry: (v) {}),
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
                          // subtitle: Text("Hello, how are you?"),
                          // trailing: Text("12:30 PM"),
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
