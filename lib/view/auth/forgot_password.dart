import 'package:easy_learners/view/utils/common_imports.dart';

class ForgotPasswordScreen extends GetWidget<AuthController> {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            vSpace(70),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/app_icon.png",
                height: 100,
                width: 100,
              ),
            ),
            vSpace(30),
            reusableText(
                giveText: "Forgot Password",
                fontsize: 35,
                fontweight: FontWeight.w600,
                textColor: Colors.black),
            // Spacer(),
            vSpace(30),
            reusableText(
                giveText:
                    "Recover your password. We will send a verification link to your email.",
                fontsize: 15,
                textAlignment: TextAlign.center,
                maxLine: 3,
                textColor: Colors.black),
            vSpace(20),
            textField(
              lableText: "Email",
              fieldController: controller.emailController,
              giveHint: "Enter Email",
              borderRadius: 20,
              onFieldEntry: (v) {},
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "Email cna't be empty";
                } else if (!GetUtils.isEmail(p0)) {
                  return "please enter a valid email";
                }
                return null;
              },
            ),
            vSpace(40),
            reuseableBtn(
              width: Get.width * 0.7,
              onTap: () {
                if (controller.emailController.text.isNotEmpty) {
                  controller.auth
                      .sendPasswordResetEmail(
                          email: controller.emailController.text)
                      .then((v) {
                    Get.offNamed(Routes.login);
                  });
                }
              },
              text: "Reset Password",
            ),
            Spacer(),
          ],
        ),
      )),
    );
  }
}
