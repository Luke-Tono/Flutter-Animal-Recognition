import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'signup.dart';
import 'image_recognition_page.dart';
import 'chrome_browser_screen.dart';
import 'search_result_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/search': (context) => ChromeBrowserScreen(),
        '/image_recognition': (context) => ImageRecognitionPage(),
        '/search_result': (context) => SearchResultPage(),
      },
    );
  }
}


