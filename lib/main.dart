import 'package:easy_learners/_bindings/init_binding.dart';
import 'package:easy_learners/firebase_options.dart';
import 'package:easy_learners/view/utils/common_imports.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 667),
        builder: (context, child) {
          return GetMaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            getPages: AppPages.pages,
            initialRoute: Routes.splasScreen,
            initialBinding: InitBinding(),
          );
        });
  }
}
