import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/Colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _bodyView(context: context),
      ),
    );
  }

  Widget _bodyView({@required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: pureWhiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/logo.png',
            width: 225,
          ),
          // const SizedBox(
          //   height: 35,
          // ),
          // const Text(
          //   '¡Bienvenidos a VoyContigo!',
          //   style: TextStyle(
          //     color: pureBlackColor,
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // const Text(
          //   'Servicio de transportación, individual o grupal con chofer como tu acompañante, ida y vuelta.',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: pureBlackColor,
          //     fontSize: 14,
          //     fontWeight: FontWeight.normal,
          //   ),
          // ),
        ],
      ),
    );
  }
}
