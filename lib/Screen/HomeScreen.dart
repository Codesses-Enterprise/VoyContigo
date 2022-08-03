import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voy_contigo/Firebase/FirebaseDataBaseService.dart';
import 'package:voy_contigo/Firebase/FirebaseStorageService.dart';
import 'package:voy_contigo/Objects/CustomerObject.dart';
import 'package:voy_contigo/Screen/BookOrderScreen.dart';
import 'package:voy_contigo/Screen/CustomerProfileScreen.dart';
import 'package:voy_contigo/Screen/CustomerYourOrderScreen.dart';
import 'package:voy_contigo/Screen/LoginScreen.dart';
import 'package:voy_contigo/Screen/SplashScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';

class HomeScreen extends StatefulWidget {
  final bool fromEditProfile;

  const HomeScreen({Key key, @required this.fromEditProfile}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomerObject _customer;

  bool _screenLoading = true;

  Future<void> getCustomer() async {
    CustomerObject customerObject =
        await FirebaseDataBaseService().getSingleCustomer();

    if (customerObject != null) {
      String customerImageName = await FirebaseStorageService()
          .getCustomerImageLink(customerObject.customerImageName);
      setState(() {
        _customer = customerObject;
        _customer.customerImageName = customerImageName;
        _screenLoading = false;
        print('m called after get');
      });
    } else {
      print('m called before get');
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    getCustomer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _screenLoading
        ? widget.fromEditProfile
            ? const Scaffold(
                body: SafeArea(
                    child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation(
                          orangeColor,
                        ),
                      ),
                    ),
                  ),
                )),
              )
            : SplashScreen()
        : Scaffold(
            drawer: Drawer(
              child: SafeArea(
                child: Container(
                  color: pureWhiteColor,
                  child: Column(
                    children: [
                      _drawerHeader(),
                      const SizedBox(
                        height: 30,
                      ),
                      _singleSideMenuItem(
                        labelText: 'Casa',
                        // labelText: 'Home',
                        function: () => {
                          Navigator.pop(context),
                        },
                        menuIconIcon: 'images/side_menu_home.png',
                      ),
                      _singleSideMenuItem(
                        labelText: 'Perfil',
                        // labelText: 'My Profile',
                        function: () => {
                          Navigator.pop(context),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerProfileScreen(),
                            ),
                          )
                        },
                        menuIconIcon: 'images/side_menu_profile.png',
                      ),
                      _singleSideMenuItem(
                        labelText: 'Mis solicitudes',
                        // labelText: 'My Requests',
                        function: () => {
                          Navigator.pop(context),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerYourOrderScreen(),
                            ),
                          )
                        },
                        menuIconIcon: 'images/side_menu_my_requests.png',
                      ),
                      // _singleSideMenuItem(
                      //   labelText: 'Contact Us',
                      //   function: () => {
                      //     Navigator.pop(context),
                      //   },
                      //   menuIconIcon: 'images/side_menu_about.png',
                      //   menuIcon: null,
                      // ),
                      _singleSideMenuItem(
                        labelText: 'Sobre',
                        // labelText: 'About Us',
                        function: () => {
                          Navigator.pop(context),
                        },
                        menuIconIcon: 'images/side_menu_about.png',
                      ),
                      _singleSideMenuItem(
                        labelText: 'Cerrar sesión',
                        // labelText: 'Logout',
                        function: () => {
                          FirebaseAuth.instance.signOut(),
                          Navigator.pop(context),
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          )
                        },
                        menuIconIcon: 'images/side_menu_logout.png',
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.topLeft,
                        child: Text(
                          _customer.city,
                          style: const TextStyle(
                            color: pureBlackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              // title: Text(_customer != null ? _customer.customerFirstName : ''),
              title: const Text(
                // 'Home',
                'Casa',
              ),
            ),
            body: _customer != null
                ? _bodyView()
                : const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(
                            orangeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
          );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding:
            const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // _profileView(),
            // const SizedBox(
            //   height: 20,
            // ),
            const Text(
              // 'BOOK A SERVICE WITH VOYCONTIGO',
              'RESERVAR UN SERVICIO CON VOYCONTIGO',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: pureBlackColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              // 'VoyContigo is a complete service of transportation, individual or group (up to 4 people), which includes a driver/chauffeur as your round trip companion. Go with you on your visits to the mall or supermarket, to the airport, medical appointments,\npersonal management, office errands governmental, collected from your son in the',
              'Te ofrece un servicio completo de transportación, individual o grupal (hasta 4 personas), que incluye un conductor/chofer como tu acompañante de ida y vuelta, para:',
              style: TextStyle(
                color: pureBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              // '(a) School\n(b) Sightseeing\n(c) Travel entertainment\n\n\nAmong other services',
              '•	ir al centro comercial o supermercado\n•	al aeropuerto\n•	citas médicas\n•	gestiones personales\n•	diligencias en oficinas gubernamentales\n•	recogido de tu hijo (a) en la escuela\n•	recorridos turísticos o de entretenimiento, entre otros servicios.',
              style: TextStyle(
                color: pureBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookOrderScreen(),
                ),
              ),
              height: 50,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: FOREGROUND_COLOR,
              child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    // 'Choose Service',
                    'Elija el servicio',
                    style: TEXT_STYLE_ON_FOREGROUND,
                  )),
            ),
            // Expanded(
            //   child: BookOrderScreen(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return Column(
      children: [
        Container(
          height: 140,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          decoration: const BoxDecoration(
            color: pureWhiteColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
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
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    _customer != null
                        ? _customer.getCustomerName().length > 11
                            ? '!Hola ${_customer.getCustomerName().substring(0, 11)}...'
                            : _customer.getCustomerName()
                        : '',
                    style: const TextStyle(
                      color: pureBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              _customer != null
                  ? const Icon(
                      Icons.arrow_forward_ios,
                      color: pureWhiteColor,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: const Text(
            'Te damos la bienvenida a VoyContigo, servicio de transportación, individual o grupal con chofer como tu acompañante, ida y vuelta.',
            style: TextStyle(
              color: pureBlackColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _profileView() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CustomerProfileScreen(),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       height: 100,
  //       padding: const EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //         color: pureWhiteColor,
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: const [
  //           BoxShadow(
  //             color: dullYellowColor,
  //             blurRadius: 20,
  //             offset: Offset(0, 0), // Shadow position
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   _customer.getCustomerName(),
  //                   style: const TextStyle(
  //                       color: orangeColor,
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(
  //                   height: 7,
  //                 ),
  //                 Text(
  //                   _customer.customerEmail,
  //                   style: const TextStyle(
  //                       color: dullFontColor,
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Center(
  //               child: Container(
  //                   alignment: Alignment.centerRight,
  //                   child: Container(
  //                     width: 65,
  //                     height: 65,
  //                     decoration: BoxDecoration(
  //                         border: Border.all(width: 2, color: orangeColor),
  //                         color: pureWhiteColor,
  //                         borderRadius: BorderRadius.circular(60)),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         image: const DecorationImage(
  //                             fit: BoxFit.cover,
  //                             image: AssetImage('images/user.png')),
  //                         borderRadius: BorderRadius.circular(55),
  //                         color: lightGrayColor,
  //                       ),
  //                       width: 85,
  //                       height: 85,
  //                     ),
  //                   )),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _singleSideMenuItem({
    @required String labelText,
    @required Function function,
    @required String menuIconIcon,
  }) {
    return FlatButton(
      onPressed: function,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Image.asset(
              menuIconIcon,
              width: 20,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              labelText.toUpperCase(),
              style: const TextStyle(
                color: dullFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
