import 'package:easy_learners/_models/onboarding_model.dart';
import 'package:easy_learners/view/utils/common_imports.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cnfmPasswordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isGoogleSignIn = false.obs;

  RxList<OnboardingModel> onboardingDetails = <OnboardingModel>[
    OnboardingModel(
        asset: "assets/onboarding/onboarding_1.png",
        title: "Welcome to Easy Learners",
        subtitle:
            "Your ultimate learning partner for mastering all government exams. Start your journey with expert guidance and smart study resources."),
    OnboardingModel(
        asset: "assets/onboarding/onboarding_2.png",
        title: "Learn with Smart Tools",
        subtitle:
            "Access AI-powered quizzes, personalized study plans, and real-time progress tracking to boost your learning."),
    OnboardingModel(
        asset: "assets/onboarding/onboarding_3.png",
        title: "Practice & Improve",
        subtitle:
            "Take mock tests, analyze your performance, and strengthen weak areas with our intelligent insights."),
  ].obs;

  Future signInWithGoogle() async {
    isGoogleSignIn(true);
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userDetails = await auth.signInWithCredential(credential);
      if (userDetails.user != null) {
        ServiceController.to
            .graphqlMutation(ConstantMutationQuaries.insertOne("users"), {
          "object": {
            "name": userDetails.user!.displayName,
            "email": userDetails.user!.email,
            "firebase_uid": userDetails.user!.uid,
            "phone_number": userDetails.user!.phoneNumber,
            "email_verified": userDetails.user!.emailVerified,
            "profile_picture": userDetails.user!.photoURL
          }
        }).then((value) {
          isGoogleSignIn(false);
          Get.offAllNamed(Routes.bottomNav);
        });
      }
      printInfo(info: userDetails.user.toString());
      return userDetails;
    }
  }

  Future signUpWithEmail() async {
    try {
      isLoading(true);
      await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);

      if (auth.currentUser != null) {
        ServiceController.to
            .graphqlMutation(ConstantMutationQuaries.insertOne("users"), {
          "object": {
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "firebase_uid": auth.currentUser!.uid,
            "phone_number": "",
            "email_verified": false,
            "profile_picture": ""
          }
        }).then((value) {
          isLoading(false);

          Get.offAllNamed(Routes.bottomNav);
        });
        snackbarWidget(title: "User created successfully");
      }
    } catch (e) {
      printInfo(info: e.toString());
    }
  }

  Future signWithEmail() async {
    try {
      isLoading(true);
      await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      isLoading(false);
      Get.offAllNamed(Routes.bottomNav);
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      printInfo(info: e.message.toString());
      snackbarWidget(title: e.message.toString());
    }
  }
}
