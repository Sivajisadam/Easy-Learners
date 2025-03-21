import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ColorConstants {
  static const primaryColor = Color(0xff232B39);
  static const secondaryColor = Color(0xff1C2330);
  static var scaffoldBackgroundColor = Colors.grey.shade100;
  static var secondaryText = Colors.black38;
}

class AppUrls {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}
