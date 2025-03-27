import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:easy_learners/view/utils/common_imports.dart';

class LogScreen extends GetWidget<AuthController> {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey = GlobalKey();
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      giveText: "Login",
                      fontsize: 35,
                      fontweight: FontWeight.w600,
                      textColor: ColorConstants.secondaryColor),
                  vSpace(30),
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
                  vSpace(15),
                  textField(
                    lableText: "Password",
                    fieldController: controller.passwordController,
                    giveHint: "Enter Password",
                    onFieldEntry: (v) {},
                    borderRadius: 20,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return "Password can't be empty";
                      } else if (GetUtils.isLengthLessOrEqual(p0, 6)) {
                        return "Password shouble atleast contain 7 char";
                      }
                      return null;
                    },
                  ),
                  vSpace(20),
                  reuseableBtn(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          controller.signWithEmail();
                        }
                      },
                      text: "Signin",
                      borderRadius: 20,
                      isLoading: controller.isLoading.value,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      width: Get.width,
                      height: 50),
                  vSpace(8),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.forgotPassword);
                    },
                    child: reusableText(
                        giveText: "Forgot Password?",
                        fontsize: 16,
                        fontweight: FontWeight.w600,
                        textColor: ColorConstants.secondaryColor),
                  ),
                  vSpace(20),
                  reusableText(
                    giveText: "or",
                    fontsize: 16,
                    fontweight: FontWeight.w600,
                    textColor: Colors.black,
                  ),
                  vSpace(20),
                  reuseableOutlineBtn(
                    width: Get.width,
                    borderRadius: 20,
                    height: 50,
                    onTap: () {
                      controller.signInWithGoogle();
                    },
                    child: !controller.isGoogleSignIn.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              reusableText(
                                giveText: "Signin with",
                                fontsize: 16,
                                fontweight: FontWeight.w600,
                              ),
                              hSpace(10),
                              Iconify(Logos.google_2014),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  vSpace(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      reusableText(
                          giveText: "Don't have an account?",
                          fontsize: 14,
                          fontweight: FontWeight.w500,
                          textColor: Colors.black26),
                      hSpace(4),
                      GestureDetector(
                        onTap: () {
                          controller.emailController.clear();
                          controller.passwordController.clear();
                          Get.offNamed(Routes.signup);
                        },
                        child: reusableText(
                            giveText: "Signup",
                            fontsize: 14,
                            fontweight: FontWeight.w500,
                            textColor: Colors.black,
                            underline: TextDecoration.underline),
                      ),
                    ],
                  ),
                  vSpace(30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
