import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voy_contigo/Firebase/PhoneAuthService.dart';
import 'package:voy_contigo/Helpers/ScreenHelper.dart';
import 'package:voy_contigo/Objects/LoginUserObject.dart';
import 'package:voy_contigo/Screen/CustomerVerifyOTPScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';
import 'package:voy_contigo/Utils/Global.dart';
import 'package:voy_contigo/Utils/validators.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController countryTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  LoginUserObject loginUserObject = LoginUserObject();

  String phoneNumber = "", verificationId;
  String isoCode = "";
  bool codeSent = false;
  Country selectedCountry;

  bool buttonLoading = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  top: ScreenHelper.getPaddingTop(context) + 30),
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/logo.png'),
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: ScreenHelper.getPaddingTop(context) + 130),
                height: double.maxFinite,
                width: double.maxFinite,
                color: themeBlackColor.withOpacity(0.5),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    // Icon(
                    //   FontAwesomeIcons.car,
                    //   size: 50,
                    //   color: backgroundColor,
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Text(
                      'VoyContigo',
                      style: TextStyle(color: backgroundColor, fontSize: 45),
                    )
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: buildLoginPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginPanel() {
    return Container(
      margin: EdgeInsets.only(
          top: ScreenHelper.getPaddingTop(context) + 450, left: 10, right: 10),
      decoration: const BoxDecoration(
          //boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, -2), blurRadius: 2)],
          color: backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      constraints:
          BoxConstraints(minHeight: ScreenHelper.getHeight(context) * 0.7),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeBlackColor,
                    ),
                  ),
                )),

            GestureDetector(
              onTap: () => showCountryPicker(
                  context: context,
                  countryListTheme: CountryListThemeData(
                    flagSize: 25,
                    backgroundColor: Colors.white,
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    //Optional. Sets the border radius for the bottomsheet.
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    //Optional. Styles the search field.
                    inputDecoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Start typing to search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  onSelect: (Country country) => {
                        print('Select country: ${country.displayName}'),
                        setState(() {
                          countryTextController.text =
                              country.displayName.toString();
                          selectedCountry = country;
                        }),
                      }),
              child: Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: grayColor, width: 2)),
                child: TextFormField(
                  enabled: false,
                  controller: countryTextController,
                  decoration: const InputDecoration(
                    labelText: 'Chose Country',
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                  validator: (country) => validatePhoneNumber(country),
                  onSaved: (country) => loginUserObject.country = country,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: grayColor, width: 2)),
              child: TextFormField(
                controller: phoneNumberTextController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
                validator: (phoneNumber) => validatePhoneNumber(phoneNumber),
                onSaved: (phoneNumber) =>
                    loginUserObject.phoneNumber = phoneNumber,
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            //   decoration: BoxDecoration(
            //       color: backgroundColor,
            //       border: Border.all(color: grayColor, width: 2),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: TextFormField(
            //     controller: passwordTextController,
            //     obscureText: true,
            //     decoration: const InputDecoration(
            //       labelText: 'Password',
            //       contentPadding: EdgeInsets.all(10),
            //       border: InputBorder.none,
            //     ),
            //     validator: (password) => validatePasswordLength(password),
            //     onSaved: (password) => loginUserObject.password = password,
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),
            buildLoginButton(),
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 10),
            //   alignment: Alignment.center,
            //   child: Text(
            //     'Or login with',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         color: themeBlackColor.withOpacity(0.5), fontSize: 12),
            //   ),
            // ),
            // buildSocialLogin(),
            const SizedBox(
              height: 30,
            ),
            // buildRegisterButton()
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          // loginUser();
          sendOTP();
        },
        color: FOREGROUND_COLOR,
        padding: const EdgeInsets.all(15),
        child: Container(
            alignment: Alignment.center,
            child: Text(
              'Continue',
              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                  fontSize: 16, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  // Widget buildSocialLogin() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       IconButton(
  //           color: grayColor,
  //           //  shape: CircleBorder(),
  //           icon: const Icon(
  //             FontAwesomeIcons.facebook,
  //             size: 30,
  //             color: Colors.blue,
  //           ),
  //           onPressed: () {}),
  //       IconButton(
  //           color: grayColor,
  //           //  shape: CircleBorder(),
  //           icon: const Icon(
  //             FontAwesomeIcons.google,
  //             size: 30,
  //             color: PRICE_COLOR_PRIMARY,
  //           ),
  //           onPressed: () {}),
  //     ],
  //   );
  // }

  // Widget buildRegisterButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       const Text('Dont have an account?', style: TEXT_STYLE_PRIMARY),
  //       Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 20),
  //         child: RaisedButton(
  //           elevation: 0,
  //           shape: RoundedRectangleBorder(
  //               side: const BorderSide(color: grayColor, width: 2),
  //               borderRadius: BorderRadius.circular(10)),
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SignUpScreen(
  //                   country: selectedCountry, phoneNumber: '',
  //                 ),
  //               ),
  //             );
  //           },
  //           color: backgroundColor,
  //           padding: const EdgeInsets.all(10),
  //           child: Container(
  //               alignment: Alignment.center,
  //               child: const Text('Register', style: TEXT_STYLE_PRIMARY)),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Future<void> loginUser() async {
  //   try {
  //     if (!buttonLoading) {
  //       if (_loginFormKey.currentState.validate()) {
  //         _loginFormKey.currentState.save();
  //         setState(() {
  //           buttonLoading = true;
  //         });
  //
  //         CustomerObject customer = await _auth.loginUser(loginUserObject);
  //
  //         if (customer != null) {
  //           CustomerObject customerData =
  //               await FirebaseDataBaseService().getSingleCustomer();
  //
  //           Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => HomeScreen(
  //                   customer: customerData,
  //                 ),
  //               ),
  //               ModalRoute.withName(''));
  //         } else {
  //           showNormalToast(msg: 'Invalid ID OR Password1');
  //         }
  //       }
  //     } else {
  //       showNormalToast(msg: 'Please Wait!');
  //     }
  //   } on PlatformException catch (e) {
  //     showNormalToast(msg: e.message);
  //   } catch (e) {
  //     showNormalToast(msg: e.toString());
  //   } finally {
  //     setState(() {
  //       buttonLoading = false;
  //     });
  //   }
  // }

  Future<void> sendOTP() async {
    // Send OTP Code to your phone
    try {
      setState(() {
        buttonLoading = true;
      });
      if (selectedCountry == null && phoneNumberTextController.text.isEmpty) {
        showNormalToast(msg: 'Invalid_phone_number');
        setState(() {
          buttonLoading = false;
        });
        return;
      } else {
        if (selectedCountry != null && phoneNumberTextController.text != null) {
          verifyPhone(
              '+${selectedCountry.phoneCode}${phoneNumberTextController.text}');
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
                  phoneNumber:
                      '+${selectedCountry.phoneCode}${phoneNumberTextController.text}',
                  verificationId: verificationId,
                  country: selectedCountry,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          });

      // final PhoneVerificationFailed verificationfailed =
      //     (FirebaseAuthException authException) {};
      //
      // final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      //   verificationId = verId;
      //   setState(() {
      //     codeSent = true;
      //   });
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (context) => CustomerVerifyOTPScreen(
      //         phoneNumber: usernameTextController.text,
      //         verificationId: verificationId,
      //       ),
      //     ),
      //   );
      // };
      //
      // final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      //   verificationId = verId;
      // };
      //
      // await FirebaseAuth.instance.verifyPhoneNumber(
      //     phoneNumber: phoneNo,
      //     timeout: const Duration(seconds: 5),
      //     verificationCompleted: verified,
      //     verificationFailed: verificationfailed,
      //     codeSent: smsSent,
      //     codeAutoRetrievalTimeout: autoTimeout);
    } catch (e) {
      print(e.toString());
      setState(() {
        buttonLoading = false;
      });
    }
  }
}
