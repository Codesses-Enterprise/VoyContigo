import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:voy_contigo/Firebase/PhoneAuthService.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/utils/Global.dart';

class CustomerVerifyOTPScreen extends StatefulWidget {
  final String phoneNumber, verificationId;
  final Country country;

  const CustomerVerifyOTPScreen(
      {this.phoneNumber, this.verificationId, this.country});
  @override
  _CustomerVerifyOTPScreenState createState() =>
      _CustomerVerifyOTPScreenState();
}

class _CustomerVerifyOTPScreenState extends State<CustomerVerifyOTPScreen> {
  final GlobalKey<FormState> _OTPFormKey = GlobalKey<FormState>();
  String smsCode;
  bool buttonLoading = false;

  String verificationId;
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(30),
            color: pureWhiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   alignment: Alignment.center,
                //   margin: const EdgeInsets.only(
                //     top: 30,
                //   ),
                //   child: Image.asset(
                //     'images/logo.png',
                //     height: 130,
                //   ),
                // ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  // 'Phone Verification',
                  'Verificación de teléfono',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: pureBlackColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Ingrese el código OTP (One-Time Password) o contraseña enviada a su teléfono ${widget.phoneNumber}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 10,
                    color: dullFontColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                formArea(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No recibiste el código?  ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: dullFontColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => sendOTP(),
                      // onTap: () => Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => LoginScreen(),
                      //   ),
                      // ),
                      child: Container(
                        color: Colors.transparent,
                        child: const Text(
                          'reenviar',
                          style: TextStyle(
                            fontSize: 11,
                            color: orangeColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                LogInBtn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formArea() {
    return Form(
      key: _OTPFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  PinCodeTextField(
                    length: 6,
                    appContext: context,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
//                        borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveFillColor: Colors.white,
                      activeColor: dullFontColor,
                      selectedFillColor: pureWhiteColor,
                      inactiveColor: dullFontColor,
                      selectedColor: Colors.deepOrange,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: (value) {
                      print("Completed");
                      setState(() {
                        smsCode = value;
                      });
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        smsCode = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget LogInBtn() {
    return GestureDetector(
      onTap: () {
        if (!buttonLoading) {
          signInUser();
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: FOREGROUND_COLOR),
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
            : const Text('Continuar',
                style: TextStyle(
                  fontSize: 12,
                  color: pureWhiteColor,
                  fontWeight: FontWeight.w700,
                )),
      ),
    );
  }

  void signInUser() {
    try {
      if (!buttonLoading) {
        setState(() {
          buttonLoading = true;
        });
        if (_OTPFormKey.currentState.validate()) {
          _OTPFormKey.currentState.save();
          if (smsCode != null) {
            FirebaseAuthService().signInWithOTP(
              smsCode: smsCode,
              verId: widget.verificationId,
              phone: widget.phoneNumber,
              context: context,
              country: widget.country,
            );
          } else {
            setState(() {
              buttonLoading = false;
            });
          }
        } else {
          setState(() {
            buttonLoading = false;
          });
        }
      } else {
        showNormalToast(msg: 'Please Wait!');
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

  Future<void> sendOTP() async {
    // Send OTP Code to your phone
    try {
      setState(() {
        buttonLoading = true;
      });
      if (widget.phoneNumber.isEmpty) {
        showNormalToast(msg: 'Invalid_phone_number');
        setState(() {
          buttonLoading = false;
        });
        return;
      } else {
        if (widget.phoneNumber != null) {
          verifyPhoneNo(widget.phoneNumber);
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

  Future<void> verifyPhoneNo(phoneNo) async {
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
              country: widget.country,
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
                  phoneNumber: widget.phoneNumber,
                  verificationId: verificationId,
                  country: widget.country,
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
