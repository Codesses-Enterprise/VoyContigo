import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voy_contigo/Screen/HomeScreen.dart';
import 'package:voy_contigo/Screen/SplashScreen.dart';

class AppOpenSplash extends StatefulWidget {
  @override
  _AppOpenSplashState createState() => _AppOpenSplashState();
}

class _AppOpenSplashState extends State<AppOpenSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(
            fromEditProfile: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
