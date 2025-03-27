import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:easy_learners/view/utils/common_imports.dart';

class Signup extends GetWidget<AuthController> {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Obx(
      () => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: formKey,
            child: Column(
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
                    giveText: "Create Account",
                    fontsize: 35,
                    fontweight: FontWeight.w600,
                    textColor: ColorConstants.secondaryColor),
                vSpace(30),
                textField(
                  lableText: "Name",
                  fieldController: controller.nameController,
                  giveHint: "Enter Your Name",
                  borderRadius: 20,
                  onFieldEntry: (v) {},
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Name can't be empty";
                    } else if (GetUtils.isLengthLessOrEqual(p0, 2)) {
                      return "Name should be more than 2 characters";
                    }
                    return null;
                  },
                ),
                vSpace(15),
                textField(
                  fieldController: controller.emailController,
                  lableText: "Email",
                  giveHint: "Enter Email",
                  borderRadius: 20,
                  onFieldEntry: (v) {},
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Email can't be empty";
                    } else if (!GetUtils.isEmail(p0)) {
                      return "please enter a valid email";
                    }
                    return null;
                  },
                ),
                vSpace(15),
                textField(
                  lableText: "Create Password",
                  fieldController: controller.passwordController,
                  giveHint: "Create Password",
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
                vSpace(15),
                textField(
                  lableText: "Confirm Password",
                  fieldController: controller.cnfmPasswordController,
                  giveHint: "Re-enter your password",
                  onFieldEntry: (v) {},
                  borderRadius: 20,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Confirm password can't be empty";
                    } else if (p0 != controller.passwordController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                ),
                vSpace(20),
                reuseableBtn(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        controller.signUpWithEmail();
                      }
                    },
                    text: "Signup",
                    isLoading: controller.isLoading.value,
                    borderRadius: 20,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    width: Get.width,
                    height: 50),
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
                              giveText: "Signup with",
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
                        giveText: "Already have an account?",
                        fontsize: 14,
                        fontweight: FontWeight.w500,
                        textColor: Colors.black26),
                    hSpace(4),
                    GestureDetector(
                      onTap: () {
                        controller.emailController.clear();
                        controller.passwordController.clear();

                        Get.offNamed(Routes.login);
                      },
                      child: reusableText(
                          giveText: "Signin",
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
    );
  }
}
