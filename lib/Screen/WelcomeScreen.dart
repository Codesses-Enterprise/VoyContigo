import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voy_contigo/Screen/HomeScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(
            fromEditProfile: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '¡Bienvenidos a VoyContigo!',
                style: TextStyle(
                  fontSize: 16,
                  color: pureBlackColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Servicio de transportación, individual o grupal con chofer\ncomo tu acompañante, ida y vuelta.',
                style: TextStyle(
                  fontSize: 10,
                  color: pureBlackColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
