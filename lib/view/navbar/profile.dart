import 'package:easy_learners/_controllers/bottom_nav_controller.dart';
import 'package:easy_learners/view/utils/constants.dart';
import 'package:easy_learners/view/utils/reusable_widget.dart';
import 'package:easy_learners/view/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends GetWidget<BottomNavController> {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isProfileLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        backgroundColor: ColorConstants.scaffoldBackgroundColor,
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Center(),
              vSpace(50),
              reusableText(
                  giveText: "Profile",
                  fontsize: 28,
                  fontweight: FontWeight.w600,
                  textAlignment: TextAlign.center),
              vSpace(20),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      vSpace(40),
                      reuseContainer(
                        giveHeight: 120,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        giveColor: Colors.white,
                        giveWidth: Get.width,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Visibility(
                          visible: controller
                              .userDetails.profilePricture!.isNotEmpty,
                          replacement: CircleAvatar(
                            radius: 42,
                            backgroundColor: ColorConstants.secondaryText,
                            child: Icon(Icons.person, size: 50),
                          ),
                          child: Image.network(
                            controller.userDetails.profilePricture.toString(),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      vSpace(20),
                      reusableText(
                          giveText: controller.userDetails.name.toString(),
                          fontsize: 22,
                          fontweight: FontWeight.w600),
                      vSpace(10),
                    ],
                  ),
                ],
              ),
              vSpace(30),
              reuseContainer(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 16),
                giveColor: Colors.white,
                giveWidth: Get.width,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText(
                          giveText: "Contact Info",
                          fontsize: 18,
                          fontweight: FontWeight.w500),
                      vSpace(10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              backgroundColor:
                                  ColorConstants.scaffoldBackgroundColor,
                              child: Icon(Icons.email_outlined, size: 20)),
                          hSpace(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              reusableText(
                                  giveText: "Email",
                                  fontsize: 16,
                                  fontweight: FontWeight.w600,
                                  textColor: ColorConstants.secondaryText),
                              vSpace(5),
                              reusableText(
                                  giveText:
                                      controller.userDetails.email.toString(),
                                  fontsize: 16,
                                  fontweight: FontWeight.w600),
                            ],
                          ),
                          Spacer(),
                          Visibility(
                              visible:
                                  controller.userDetails.emailVerified! == true,
                              child: Icon(Icons.verified, color: Colors.green)),
                        ],
                      ),
                      vSpace(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              backgroundColor:
                                  ColorConstants.scaffoldBackgroundColor,
                              child: Icon(Icons.phone, size: 20)),
                          hSpace(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              reusableText(
                                  giveText: "Mobile Number",
                                  fontsize: 16,
                                  fontweight: FontWeight.w600,
                                  textColor: ColorConstants.secondaryText),
                              vSpace(5),
                              Visibility(
                                visible: !controller.editMobile.value,
                                child: reusableText(
                                    giveText:
                                        controller.userDetails.phone != null
                                            ? controller.userDetails.phone
                                                .toString()
                                            : "---",
                                    fontsize: 16,
                                    fontweight: FontWeight.w600),
                              ),
                            ],
                          ),
                          // Spacer(),
                          // Visibility(
                          //     visible: !controller.editMobile.value,
                          //     child: GestureDetector(
                          //         onTap: () {
                          //           controller.editMobile(true);
                          //         },
                          //         child: Icon(Icons.edit,
                          //             color: ColorConstants.secondaryText))),
                        ],
                      )
                    ]),
              ),
              vSpace(30),
              reuseableOutlineBtn(
                  width: Get.width * 0.7,
                  onTap: () {
                    controller.auth.signOut();
                    controller.googleSignIn.signOut();
                    Get.delete<BottomNavController>(force: true);
                    Get.offAllNamed(Routes.login);
                  },
                  text: "Signout",
                  textColor: Colors.red),
            ])),
      );
    });
  }
}
