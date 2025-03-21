import 'package:easy_learners/view/utils/common_imports.dart';

class Onboarding extends GetWidget<AuthController> {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.onboardingDetails.length,
              onPageChanged: (value) {
                controller.currentPage(value);
              },
              itemBuilder: (context, index) {
                return onBoardingWidget(
                    asset: controller.onboardingDetails[index].asset,
                    title: controller.onboardingDetails[index].title,
                    subtitle: controller.onboardingDetails[index].subtitle);
              },
            ),
          ),
          // vSpace(30),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => buildDot(index: index),
              ),
            ),
          ),
          vSpace(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: reuseableBtn(
              text: "Create your account",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 50,
              width: Get.width,
              onTap: () {
                LocalStorage.writeData("isUserOnBoarded", "true");
                Get.offAllNamed(Routes.signup);
              },
            ),
          ),
          vSpace(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: reuseableOutlineBtn(
                onTap: () {
                  LocalStorage.writeData("isUserOnBoarded", "true");
                  Get.offAllNamed(Routes.login);
                },
                text: "Login",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 50,
                width: Get.width),
          ),
          vSpace(50),
        ],
      )),
    );
  }

  Widget onBoardingWidget(
      {required String asset,
      required String title,
      required String subtitle}) {
    return Column(
      children: [
        vSpace(70),
        Image.asset(asset),
        vSpace(30),
        reusableText(
            giveText: title, fontsize: 24, fontweight: FontWeight.w700),
        vSpace(16),
        reusableText(
          giveText: subtitle,
          fontsize: 16,
          fontweight: FontWeight.w400,
          maxLine: 3,
          textAlignment: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      height: 6.h,
      width: controller.currentPage.value == index ? 20.w : 6.h,
      margin: EdgeInsets.only(right: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: controller.currentPage.value == index
            ? ColorConstants.primaryColor
            : Colors.grey,
      ),
    );
  }
}
