import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voy_contigo/Firebase/PhoneAuthService.dart';
import 'package:voy_contigo/Objects/LoginUserObject.dart';
import 'package:voy_contigo/Screen/CustomerVerifyOTPScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';
import 'package:voy_contigo/Utils/Global.dart';
import 'package:voy_contigo/Utils/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countryTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  LoginUserObject loginUserObject = LoginUserObject();

  String phoneNumber = "", verificationId;
  String isoCode = "";
  bool codeSent = false;
  Country selectedCountry;

  bool buttonLoading = false;

  @override
  void initState() {
    phoneNumberTextController.text = '+1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset('images/just_logo.png'),
            ),
            _bodyView(),
          ],
        ),
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white70,
      ),
      child: Form(
        key: _loginFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Container(
              //     margin: const EdgeInsets.only(
              //       top: 10,
              //     ),
              //     child: const Center(
              //       child: Text(
              //         'Login',
              //         style: TextStyle(
              //           fontSize: 25,
              //           fontWeight: FontWeight.bold,
              //           color: themeBlackColor,
              //         ),
              //       ),
              //     )),
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'images/logo.png',
                width: 200,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4.5,
              ),
              // GestureDetector(
              //   onTap: () => showCountryPicker(
              //       context: context,
              //       countryListTheme: CountryListThemeData(
              //         flagSize: 25,
              //         backgroundColor: Colors.white,
              //         textStyle:
              //             const TextStyle(fontSize: 16, color: Colors.blueGrey),
              //         //Optional. Sets the border radius for the bottomsheet.
              //         borderRadius: const BorderRadius.only(
              //           topLeft: Radius.circular(20.0),
              //           topRight: Radius.circular(20.0),
              //         ),
              //         //Optional. Styles the search field.
              //         inputDecoration: InputDecoration(
              //           labelText: 'Search',
              //           hintText: 'Start typing to search',
              //           prefixIcon: const Icon(Icons.search),
              //           border: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: const Color(0xFF8C98A8).withOpacity(0.2),
              //             ),
              //           ),
              //         ),
              //       ),
              //       onSelect: (Country country) => {
              //             print('Select country: ${country.displayName}'),
              //             setState(() {
              //               countryTextController.text =
              //                   country.displayName.toString();
              //               selectedCountry = country;
              //               // phoneNumberTextController.text = country.countryCode;
              //             }),
              //           }),
              //   child: TextFormField(
              //     enabled: false,
              //     controller: countryTextController,
              //     decoration: const InputDecoration(
              //       labelText: 'Chose Country*',
              //       labelStyle: TextStyle(
              //         color: pureBlackColor,
              //       ),
              //       contentPadding: EdgeInsets.all(0),
              //       border: UnderlineInputBorder(
              //           // borderSide: BorderSide(color: Colors.cyan),
              //           ),
              //     ),
              //     validator: (country) => validatePhoneNumber(country),
              //     onSaved: (country) => loginUserObject.country = country,
              //   ),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              TextFormField(
                controller: phoneNumberTextController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                      color: labelFontColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                  labelText: 'NÚMERO DE TELÉFONO*',
                  contentPadding: EdgeInsets.all(0),
                  border: UnderlineInputBorder(),
                ),
                validator: (phoneNumber) => validatePhoneNumber(phoneNumber),
                onSaved: (phoneNumber) =>
                    loginUserObject.phoneNumber = phoneNumber,
              ),
              const SizedBox(
                height: 80,
              ),
              buildLoginButton(),

              // buildRegisterButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return MaterialButton(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: () {
        // loginUser();
        sendOTP();
      },
      height: 50,
      color: FOREGROUND_COLOR,
      // padding: const EdgeInsets.all(15),
      child: Container(
        alignment: Alignment.center,
        child: buttonLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                ),
              )
            : const Text(
                // 'Continue',
                'Continuar',
                style: TEXT_STYLE_ON_FOREGROUND,
              ),
      ),
    );
  }

  Future<void> sendOTP() async {
    // Send OTP Code to your phone
    try {
      setState(() {
        buttonLoading = true;
      });
      if (phoneNumberTextController.text.isEmpty) {
        showNormalToast(msg: 'Invalid_phone_number');
        setState(() {
          buttonLoading = false;
        });
        return;
      } else {
        if (phoneNumberTextController.text != null) {
          verifyPhone(phoneNumberTextController.text);
        } else {
          setState(() {
            buttonLoading = false;
          });
        }
      }
    } on PlatformException catch (e) {
      print(e.message);
      setState(() {
        buttonLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        buttonLoading = false;
      });
    }
  }

  Future<void> verifyPhone(phoneNo) async {
    try {
      print('m called $phoneNo.');

      // (authResult) {
      //   FirebaseAuthService().signIn(authResult, context, phoneNo);
      // };
      //
      // final PhoneVerificationCompleted verified = await (authResult) {
      //   FirebaseAuthService().signIn(authResult, context, phoneNo);
      // };

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 5),
          verificationCompleted: (authResult) {
            FirebaseAuthService().signIn(
              authCreds: authResult,
              context: context,
              phone: phoneNo,
              country: selectedCountry,
            );
          },
          verificationFailed: (authException) {
            print('authException: ${authException.message}');
          },
          codeSent: (String verId, [int forceResend]) {
            verificationId = verId;
            setState(() {
              codeSent = true;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CustomerVerifyOTPScreen(
                  phoneNumber: phoneNumberTextController.text,
                  verificationId: verificationId,
                  country: selectedCountry,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          });
    } catch (e) {
      print(e.toString());
      setState(() {
        buttonLoading = false;
      });
    }
  }
}
