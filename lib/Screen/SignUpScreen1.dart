import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voy_contigo/Firebase/FirebaseDataBaseService.dart';
import 'package:voy_contigo/Helpers/ScreenHelper.dart';
import 'package:voy_contigo/Objects/CustomerObject.dart';
import 'package:voy_contigo/Screen/HomeScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';
import 'package:voy_contigo/Utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  final String phoneNumber;
  final Country country;

  const SignUpScreen(
      {Key key, @required this.phoneNumber, @required this.country})
      : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  bool buttonLoading = false;

  final CustomerObject _customer = CustomerObject();

  @override
  void initState() {
    phoneTextController.text = widget.phoneNumber;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    top: ScreenHelper.getPaddingTop(context) + 30),
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
                      'VoyContigo!',
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
          top: ScreenHelper.getPaddingTop(context) + 150, left: 10, right: 10),
      decoration: const BoxDecoration(
          //boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, -2), blurRadius: 2)],
          color: backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      constraints:
          BoxConstraints(minHeight: ScreenHelper.getHeight(context) * 0.7),
      child: Form(
        key: _signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: const Center(
                  child: Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: themeBlackColor,
                    ),
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: grayColor, width: 2)),
              child: TextFormField(
                controller: firstNameTextController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
                validator: (customerFirstName) =>
                    requiredField(customerFirstName, 'First Name'),
                onSaved: (customerFirstName) =>
                    _customer.customerFirstName = customerFirstName,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: grayColor, width: 2)),
              child: TextFormField(
                controller: lastNameTextController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
                validator: (customerLastName) =>
                    requiredField(customerLastName, 'Last Name'),
                onSaved: (customerLastName) =>
                    _customer.customerLastName = customerLastName,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: grayColor, width: 2)),
              child: TextFormField(
                controller: emailTextController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'example@mail.com',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (customerEmail) => customerEmail.isNotEmpty
                    ? validateEmail(customerEmail)
                    : null,
                onSaved: (customerEmail) =>
                    _customer.customerEmail = customerEmail,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: grayColor, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneTextController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
                // validator: (value) => validatePasswordLength(value),
                onSaved: (customerPhoneNumber) =>
                    _customer.customerPhoneNumber = customerPhoneNumber,
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            //   decoration: BoxDecoration(
            //       color: backgroundColor,
            //       border: Border.all(color: grayColor, width: 2),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: TextFormField(
            //     controller: confirmPasswordTextController,
            //     keyboardType: TextInputType.visiblePassword,
            //     obscureText: true,
            //     decoration: const InputDecoration(
            //       labelText: 'ConfirmPassword',
            //       contentPadding: EdgeInsets.all(10),
            //       border: InputBorder.none,
            //     ),
            //     validator: (value) =>
            //         validatePasswordMatch(value, passwordTextController.text),
            //     onSaved: (password) =>
            //         _customer.customerConfirmPassword = password,
            //   ),
            // ),
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
        onPressed: () async {
          _validateRegisterInput();
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

  Widget buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Have an account?', style: TEXT_STYLE_PRIMARY),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: grayColor, width: 2),
                borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              Navigator.pop(context);
            },
            color: backgroundColor,
            padding: const EdgeInsets.all(10),
            child: Container(
                alignment: Alignment.center,
                child: const Text('Login', style: TEXT_STYLE_PRIMARY)),
          ),
        ),
      ],
    );
  }

  void _validateRegisterInput() async {
    final FormState form = _signupFormKey.currentState;

    if (form.validate()) {
      // print(
      //     '${_customer.customerPassword} and ${_customer.customerConfirmPassword}');
      // if (_customer.customerPassword == _customer.customerConfirmPassword) {
      form.save();
      setState(() {
        buttonLoading = true;
      });
      try {
        // UserCredential user = await FirebaseAuth.instance
        //     .createUserWithEmailAndPassword(
        //         email: _customer.customerEmail,
        //         password: _customer.customerPassword);

        // if (user != null) {
        // print(user.user.uid);
        _customer.customerUID = FirebaseAuth.instance.currentUser.uid;
        _customer.country = widget.country;
        // _customer
        await FirebaseDataBaseService()
            .addNewCustomer(customer: _customer)
            .then((dataUpdated) async => {
                  if (dataUpdated)
                    {
                      // await getDeviceTokenForCustomer(firebaseUser.uid),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(
                              fromEditProfile: false,
                            ),
                          ),
                          ModalRoute.withName('')),
                    }
                });
        // }
      } catch (error) {
        print(error.code);
        switch (error.code) {
          case "email-already-in-use":
            {
              setState(() {
                buttonLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: const Text("This email is already in use."),
                      ),
                    );
                  });
            }
            break;
          case "weak-password":
            {
              setState(() {
                buttonLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Text(
                          "The password must be 6 characters long or more."),
                    );
                  });
            }
            break;
          // // default:
          // //   {}
        }
      } finally {
        setState(() {
          buttonLoading = false;
        });
      }
      // } else {
      //   showNormalToast(msg: 'Password Not Matched!');
      // }
    }
  }
}
//
// class LoginScreen extends StatelessWidget {
//   final _phoneController = TextEditingController();
//   final _passController = TextEditingController();
//   //Place A
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//           padding: EdgeInsets.all(32),
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text("Login", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),
//
//                 SizedBox(height: 16,),
//
//                 TextFormField(
//                   decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[200])
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[300])
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       hintText: "Phone Number"
//
//                   ),
//                   controller: _phoneController,
//                 ),
//
//                 SizedBox(height: 16,),
//
//                 TextFormField(
//                   decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[200])
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[300])
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       hintText: "Password"
//
//                   ),
//
//                   controller: _passController,
//                 ),
//
//                 SizedBox(height: 16,),
//
//                 Container(
//                   width: double.infinity,
//                   child: FlatButton(
//                     child: Text("Login"),
//                     textColor: Colors.white,
//                     padding: EdgeInsets.all(16),
//                     onPressed: (){
//                       //code for sign in
//                       Place B
//                     },
//                     color: Colors.blue,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }
