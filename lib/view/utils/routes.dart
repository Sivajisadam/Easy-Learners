import 'package:easy_learners/_bindings/bottom_nav_binding.dart';
import 'package:easy_learners/_bindings/chat_binding.dart';
import 'package:easy_learners/_bindings/login_binding.dart';
import 'package:easy_learners/view/auth/forgot_password.dart';
import 'package:easy_learners/view/navbar/bottom_nav.dart';
import 'package:easy_learners/view/auth/login.dart';
import 'package:easy_learners/view/auth/onboarding.dart';
import 'package:easy_learners/view/auth/signup.dart';
import 'package:easy_learners/view/auth/splash_screen.dart';
import 'package:easy_learners/view/navbar/chat_details.dart';
import 'package:get/get.dart';

class Routes {
  static const String splasScreen = "/splash-screen";
  static const String onboarding = "/onboarding";
  static const String home = "/home";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String forgotPassword = "/forgot-password";
  static const String bottomNav = "/bottom-nav";
  static const String homeScreen = "/home-screen";
  static const String search = "/search";
  static const String profile = "/profile";
  static const String settings = "/settings";
  static const String chatDetails = '/chat-details';
}

class AppPages extends RxList<GetPage> {
  static List<GetPage> pages = [
    GetPage(
      name: Routes.splasScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
        name: Routes.onboarding,
        page: () => const Onboarding(),
        binding: AuthBinding()),
    GetPage(
      name: Routes.login,
      page: () => const LogScreen(),
      binding: AuthBinding(),
    ),
    GetPage(name: Routes.signup, page: () => const Signup()),
    GetPage(
        name: Routes.bottomNav,
        page: () => const BottomNav(),
        binding: BottomNavBinding()),
    GetPage(
        name: Routes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(
        name: Routes.chatDetails,
        page: () => const ChatDetails(),
        binding: ChatBinding()),
  ];
}
