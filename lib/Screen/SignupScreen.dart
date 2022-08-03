import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voy_contigo/Firebase/FirebaseDataBaseService.dart';
import 'package:voy_contigo/Objects/CustomerObject.dart';
import 'package:voy_contigo/Screen/WelcomeScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';
import 'package:voy_contigo/Utils/validators.dart';

class SignupScreen extends StatefulWidget {
  final String phoneNumber;
  // final Country country;

  const SignupScreen({
    Key key,
    @required this.phoneNumber,
  }) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  bool buttonLoading = false;

  final CustomerObject _customer = CustomerObject();

  @override
  void initState() {
    passwordTextController.text = widget.phoneNumber;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: pureWhiteColor,
      ),
      child: Form(
        key: _signupFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                // 'Fill out this form',
                'Complete el formulario con su información',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: themeBlackColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                child: TextFormField(
                  controller: firstNameTextController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'PRIMER NOMBRE *',
                    labelStyle: labelTextStyle,
                    // labelText: 'First Name',
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(
                        // borderSide: BorderSide(color: Colors.cyan),
                        ),
                  ),
                  // validator: (customerFirstName) =>
                  //     requiredField(customerFirstName, 'First Name'),
                  validator: (customerFirstName) =>
                      requiredField(customerFirstName, 'PRIMER NOMBRE'),
                  onSaved: (customerFirstName) =>
                      _customer.customerFirstName = customerFirstName,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: lastNameTextController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    // labelText: 'Last Name',
                    labelText: 'APELLIDO *',
                    labelStyle: labelTextStyle,
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(
                        // borderSide: BorderSide(color: Colors.cyan),
                        ),
                  ),
                  // validator: (customerLastName) =>
                  //     requiredField(customerLastName, 'Last Name'),
                  validator: (customerLastName) =>
                      requiredField(customerLastName, 'APELLIDO'),
                  onSaved: (customerLastName) =>
                      _customer.customerLastName = customerLastName,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: emailTextController,
                  decoration: const InputDecoration(
                    // labelText: 'Email Address',
                    labelText: 'EMAIL',
                    hintText: 'example@mail.com',
                    labelStyle: labelTextStyle,
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(
                        // borderSide: BorderSide(color: Colors.cyan),
                        ),
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
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: passwordTextController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'NÚMERO DE TELÉFONO',
                    labelStyle: labelTextStyle,
                    // labelText: 'Phone Number',
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(
                        // borderSide: BorderSide(color: Colors.cyan),
                        ),
                  ),
                  // validator: (value) => validatePasswordLength(value),
                  onSaved: (customerPhoneNumber) =>
                      _customer.customerPhoneNumber = customerPhoneNumber,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MUNICIPIO DONDE VIVE *',
                        style: labelTextStyle,
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _customer.area,
                        items: <String>[
                          'METRO',
                          'ISLA',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (area) {
                          setState(() {
                            _customer.area = area;
                          });
                        },
                      ),
                    ],
                  )
                  // child: TextFormField(
                  //   // controller: firstNameTextController,
                  //   keyboardType: TextInputType.name,
                  //   decoration: const InputDecoration(
                  //     labelText: 'MUNICIPIO DONDE VIVE *',
                  //     labelStyle: labelTextStyle,
                  //     // labelText: 'Area*',
                  //     contentPadding: EdgeInsets.all(0),
                  //     border: UnderlineInputBorder(
                  //         // borderSide: BorderSide(color: Colors.cyan),
                  //         ),
                  //   ),
                  //   validator: (area) => requiredField(area, 'Area'),
                  //   // validator: (customerFirstName) =>
                  //   //     requiredField(customerFirstName, 'Area'),
                  //   onSaved: (area) => _customer.area = area,
                  // ),
                  ),
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                child: TextFormField(
                  // controller: firstNameTextController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Dirección *',
                    labelStyle: labelTextStyle,
                    // labelText: 'City*',
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(
                        // borderSide: BorderSide(color: Colors.cyan),
                        ),
                  ),
                  validator: (city) => requiredField(city, 'Dirección'),
                  // validator: (customerFirstName) =>
                  //     requiredField(customerFirstName, 'City'),
                  onSaved: (city) => _customer.city = city,
                ),
              ),
              buildSignupButton(),
              const SizedBox(
                height: 30,
              ),
              // buildRegisterButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignupButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        height: 50,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () async {
          _validateRegisterInput();
        },
        color: FOREGROUND_COLOR,
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
                  )),
      ),
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
        // _customer.country = widget.country;
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
                            builder: (context) => WelcomeScreen(),
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
                    return const AlertDialog(
                      content: Text("This email is already in use."),
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
