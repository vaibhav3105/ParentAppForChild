import 'package:firebase_2_apps/auth/login_screen.dart';
import 'package:firebase_2_apps/auth/verify_email_screen.dart';
import 'package:firebase_2_apps/utils/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInAndIntroStatus();
  }

  Future getUserLoggedInAndIntroStatus() async {
    await Helper.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parent App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFee7b64),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _isSignedIn ? VerifyEmailScreen() : LoginScreen(),
    );
  }
}
