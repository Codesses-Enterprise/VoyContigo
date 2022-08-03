import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voy_contigo/Firebase/FirebaseDataBaseService.dart';
import 'package:voy_contigo/Firebase/FirebaseStorageService.dart';
import 'package:voy_contigo/Objects/CustomerObject.dart';
import 'package:voy_contigo/Screen/HomeScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';
import 'package:voy_contigo/Utils/Global.dart';
import 'package:voy_contigo/Utils/validators.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController addressEdtController = TextEditingController();
  final GlobalKey<FormState> _profileUpdateFormKey = GlobalKey<FormState>();

  CustomerObject _customer;
  bool buttonLoading = false;

  Future<void> getProfile() async {
    setState(() {
      buttonLoading = true;
    });

    CustomerObject customerData =
        await FirebaseDataBaseService().getSingleCustomer();
    String customerImageName = await FirebaseStorageService()
        .getCustomerImageLink(customerData.customerImageName);

    setState(() {
      buttonLoading = false;
      _customer = customerData;
      _customer.customerImageName = customerImageName;
      firstNameTextController.text = customerData.customerFirstName;
      lastNameTextController.text = customerData.customerLastName;
      emailTextController.text = customerData.customerEmail == 'not avail'
          ? ''
          : customerData.customerEmail;
      phoneTextController.text = customerData.customerPhoneNumber;
      addressEdtController.text = customerData.city;
    });
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // 'Profile',
          'Perfil',
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: backgroundColor,
          child: _customer != null
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _ImageView(),
                      _formArea(),
                    ],
                  ),
                )
              : const Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _ImageView() {
    // print('customer Image name ${_customer.customerImageName}');

    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _customer.customerImage != null
                        ? FileImage(_customer.customerImage)
                        : _customer.customerImageName != null
                            ? NetworkImage(_customer.customerImageName)
                            : const AssetImage('images/user.png'),
                  ),
                  borderRadius: BorderRadius.circular(55),
                  color: lightGrayColor,
                ),
                width: 100,
                height: 100,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => pickImage(),
                child: Container(
                  margin: const EdgeInsets.only(top: 50, left: 70),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: buttonLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.edit,
                          color: orangeColor,
                          size: 20,
                        ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _formArea() {
    return Form(
      key: _profileUpdateFormKey,
      child: Container(
        margin: const EdgeInsets.only(right: 30, left: 30, top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  validator: (customerEmail) => customerEmail.length > 1
                      ? customerEmail == 'not avail'
                          ? null
                          : validateEmail(customerEmail)
                      : null,
                  onSaved: (customerEmail) =>
                      _customer.customerEmail = customerEmail,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneTextController,
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
                  controller: addressEdtController,
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
              // buildSignupButton(),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: MaterialButton(
                  elevation: 10,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: _updateProfile,
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
                              'Actualizar',
                              style: TEXT_STYLE_ON_FOREGROUND,
                            )),
                ),
              ),
              // buildRegisterButton()
            ],
          ),
        ),
      ),
    );
    //   Form(
    //   child: Container(
    //     margin: const EdgeInsets.only(right: 30, left: 30, top: 20),
    //     child: Column(
    //       children: <Widget>[
    //         _singleValue(
    //           // title: 'FIRST NAME*',
    //           title: 'PRIMER NOMBRE *',
    //           value: _customer.customerFirstName,
    //         ),
    //         const SizedBox(
    //           height: 15,
    //         ),
    //         _singleValue(
    //           // title: 'LAST NAME*',
    //           title: 'APELLIDO *',
    //           value: _customer.customerLastName,
    //         ),
    //         const SizedBox(
    //           height: 15,
    //         ),
    //         _singleValue(
    //           // title: 'EMAIL',
    //           title: 'EMAIL',
    //           value: _customer.customerEmail,
    //         ),
    //         const SizedBox(
    //           height: 15,
    //         ),
    //         _singleValue(
    //           // title: 'PHONE NUMBER',
    //           title: 'NÚMERO DE TELÉFONO',
    //           value: _customer.customerPhoneNumber,
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         _singleValue(
    //           // title: 'Area',
    //           title: 'MUNICIPIO DONDE VIVE *',
    //           value: _customer.area,
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         _singleValue(
    //           // title: 'City',
    //           title: 'Dirección *',
    //           value: _customer.city,
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         Container(
    //           margin: const EdgeInsets.only(top: 20),
    //           child: MaterialButton(
    //             elevation: 10,
    //             height: 50,
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8)),
    //             onPressed: () async {
    //               // _validateRegisterInput();
    //             },
    //             color: FOREGROUND_COLOR,
    //             child: Container(
    //                 alignment: Alignment.center,
    //                 child: const Text(
    //                   'Actualizar',
    //                   style: TEXT_STYLE_ON_FOREGROUND,
    //                 )),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _singleValue({@required String title, @required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: labelFontColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black45, width: 0.5),
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              color: pureBlackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  void _updateProfile() async {
    final FormState form = _profileUpdateFormKey.currentState;

    if (form.validate()) {
      form.save();
      setState(() {
        buttonLoading = true;
      });
      try {
        await FirebaseDataBaseService()
            .updateCustomer(customer: _customer)
            .then((dataUpdated) async => {
                  if (dataUpdated)
                    {
                      // await getDeviceTokenForCustomer(firebaseUser.uid),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(
                              fromEditProfile: true,
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

  Future<void> pickImage() async {
    File image;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    if (image != null) {
      setState(() {
        _customer.customerImage = image;
      });
      _updateProfilePicture();
    }
  }

  Future<void> _updateProfilePicture() async {
    try {
      if (_customer.customerImage != null) {
        setState(() {
          buttonLoading = true;
        });

        // _refresh();s
        FirebaseStorageService().addCustomerImageToStorage(
            _customer.customerUID, _customer.customerImage);

        bool done = await FirebaseDataBaseService()
            .editCustomerProfilePicture(_customer);

        if (done) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(
                  fromEditProfile: true,
                ),
              ),
              ModalRoute.withName('/'));
        }
      }
    } on PlatformException catch (e) {
      showNormalToast(msg: e.message);
    } catch (e) {
      showNormalToast(
          msg:
              'The connection failed because the device is not connected to the internet');
    } finally {
      setState(() {
        buttonLoading = false;
      });
    }
  }
}
