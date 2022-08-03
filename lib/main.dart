import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voy_contigo/Screen/AppOpenSplash.dart';
import 'package:voy_contigo/Screen/HomeScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  User firebaseUser = FirebaseAuth.instance.currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: pureWhiteColor),
          backgroundColor: orangeColor,
          titleTextStyle: TextStyle(
              color: pureWhiteColor, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        primarySwatch: Colors.orange,
      ),
      home: firebaseUser != null
          ? const HomeScreen(
              fromEditProfile: false,
            )
          : AppOpenSplash(),
    );
  }
}
