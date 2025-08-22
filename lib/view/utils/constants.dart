import 'package:easy_learners/view/utils/common_imports.dart';

class ColorConstants {
  static const primaryColor = Color(0xff232B39);
  static const secondaryColor = Color(0xff1C2330);
  static var scaffoldBackgroundColor = Colors.grey.shade100;
  static var secondaryText = Colors.black38;
}

class AppUrls {
  static String get baseUrl => "https://easy-learners.hasura.app/v1/graphql/";
  static String get apiKey => LocalStorage.readData("apiKey").toString();
  static String get geminiApiKey => LocalStorage.readData("geminiApiKey").toString();
  static String get chatApi =>
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent";
}
