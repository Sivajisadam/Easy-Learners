import 'package:easy_learners/view/profile/widgets.dart';
import 'package:easy_learners/view/utils/common_imports.dart';

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
                      contactInfoWidget(controller,
                          title: "Email",
                          value: controller.userDetails.email.toString()),
                      vSpace(20),
                      contactInfoWidget(
                        controller,
                        title: "Mobile Number",
                        value: controller.userDetails.phone != null
                            ? controller.userDetails.phone.toString()
                            : "---",
                      ),
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
