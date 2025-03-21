import 'package:easy_learners/view/utils/common_imports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 2), () {
      LocalStorage.readData("isUserOnBoarded").then((value) {
        if (value != null) {
          auth.authStateChanges().listen((User? user) {
            if (user == null) {
              Get.offAllNamed(Routes.login);
            } else {
              Get.offAllNamed(Routes.bottomNav);
            }
          });
        } else {
          Get.offAllNamed(Routes.onboarding);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/app_icon.png"),
      ),
    );
  }
}
