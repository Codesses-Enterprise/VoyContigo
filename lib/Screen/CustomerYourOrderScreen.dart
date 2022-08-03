import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voy_contigo/Firebase/FirebaseDataBaseService.dart';
import 'package:voy_contigo/Objects/RequestObject.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';

class CustomerYourOrderScreen extends StatefulWidget {
  @override
  _CustomerYourOrderScreenState createState() =>
      _CustomerYourOrderScreenState();
}

class _CustomerYourOrderScreenState extends State<CustomerYourOrderScreen> {
  bool _buttonLoading = false;

  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  List<RequestObject> requestsList = [];

  Future<void> getRequests() async {
    List<RequestObject> requestsListData =
        await FirebaseDataBaseService().getMyOrders();
    if (requestsListData != null) {
      setState(() {
        requestsList = requestsListData;
      });
    }
  }

  @override
  void initState() {
    getRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // 'My Requests',
          'Mis solicitudes',
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF7F7F8),
          child: _bodyView(),
        ),
      ),
    );
  }

  Widget _collectedOrderBtn() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: const Text(
          'Delivered',
          style: TextStyle(color: pureWhiteColor),
        ),
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: requestsList.length,
        itemBuilder: (context, index) {
          return _singleRequestView(request: requestsList[index]);
        },
      ),
    );
  }

  Widget _singleRequestView({@required RequestObject request}) {
    return GestureDetector(
      onTap: () => showBottomSheet(request: request),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: pureWhiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5, color: Colors.black45),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 115,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        request.requestType.title,
                        // 'Transportation service with\ndriver / escort',
                        // 'Servicio de transportación sólo (que me lleven solamente)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: themeBlackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                // 'Date: ',
                                'Fecha: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: dullFontColor,
                                ),
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(request.dateTime),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: themeBlackColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                // 'Date: ',
                                'Tiempo: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: dullFontColor,
                                ),
                              ),
                              Text(
                                MaterialLocalizations.of(context)
                                    .formatTimeOfDay(request.timeOfDay),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: themeBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            // 'Route: ',
                            'Ruta: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: dullFontColor,
                            ),
                          ),
                          Text(
                            '${request.startingPoint} - ${request.endPoint}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: themeBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  request.requestStatus,
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            // orderStatus == 'pending'
            //     ? Column(
            //         children: [
            //           const SizedBox(
            //             height: 10,
            //           ),
            //           GestureDetector(
            //             onTap: () {
            //               showAlertDialogForCancelCustomerOrder(
            //                 context,
            //                 'Are you sure to want Cancel order against ID:$orderId?',
            //                 CustomerMyOrderObject(
            //                   orderId: orderId,
            //                   orderStatus: orderStatus,
            //                   orderDate: DateTime.parse(orderDateTime),
            //                 ),
            //               );
            //             },
            //             child: Container(
            //               width: MediaQuery.of(context).size.width,
            //               padding:
            //                   const EdgeInsets.symmetric(vertical: 10),
            //               alignment: Alignment.center,
            //               decoration: BoxDecoration(
            //                   gradient: color1,
            //                   borderRadius: BorderRadius.circular(10)),
            //               child: Text(
            //                 'Cancel Order',
            //                 style: TextStyle(
            //                   color: pureWhiteColor,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     : const SizedBox(),
            // orderStatus == 'delivered'
            //     ? _reOrderButton(
            //         customerMyOrderObject: CustomerMyOrderObject(
            //           orderId: orderId,
            //           orderStatus: orderStatus,
            //           orderDate: DateTime.parse(orderDateTime),
            //         ),
            //       )
            //     : orderStatus == 'canceled'
            //         ? _reOrderButton(
            //             customerMyOrderObject: CustomerMyOrderObject(
            //               orderId: orderId,
            //               orderStatus: orderStatus,
            //               orderDate: DateTime.parse(orderDateTime),
            //             ),
            //           )
            //         : const SizedBox(),
          ],
        ),
      ),
    );
  }

  // Widget _reOrderButton(
  //     {@required CustomerMyOrderObject customerMyOrderObject}) {
  //   return Column(
  //     children: [
  //       const SizedBox(
  //         height: 10,
  //       ),
  //       GestureDetector(
  //         onTap: () => showAlertDialogForReCustomerOrder(
  //             question: 'Are you sure to Re Order?',
  //             customerMyOrderObject: customerMyOrderObject),
  //         child: Container(
  //           width: MediaQuery.of(context).size.width,
  //           padding: const EdgeInsets.symmetric(vertical: 10),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //               gradient: color1, borderRadius: BorderRadius.circular(10)),
  //           child: Text(
  //             'Re Order',
  //             style: TextStyle(
  //               color: pureWhiteColor,
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // showAlertDialogForReCustomerOrder({
  //   @required String question,
  //   @required CustomerMyOrderObject customerMyOrderObject,
  // }) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: const Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   Widget continueButton = FlatButton(
  //     child: const Text("Continue"),
  //     onPressed: () {
  //       reOrder(customerMyOrderObject: customerMyOrderObject);
  //       Navigator.pop(context);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: const Text("AlertDialog"),
  //     content: Text(question),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  //   return false;
  // }

  // Future<void> reOrder(
  //     {@required CustomerMyOrderObject customerMyOrderObject}) async {
  //   try {
  //     if (!_buttonLoading) {
  //       setState(() {
  //         _buttonLoading = true;
  //       });
  //
  //       if (globalCustomerObject != null) {
  //         await reOrderFromHistory(
  //             customerMyOrderObject: customerMyOrderObject);
  //       } else {
  //         showNormalToast('Please Sign In to place order!');
  //       }
  //     } else {
  //       showNormalToast('Please Wait!');
  //     }
  //   } on PlatformException catch (e) {
  //     print(e.message);
  //   } catch (e) {
  //     print(e.toString());
  //   } finally {
  //     setState(() {
  //       _buttonLoading = false;
  //     });
  //   }
  // }

  // Future<bool> reOrderFromHistory({
  //   @required CustomerMyOrderObject customerMyOrderObject,
  // }) async {
  //   try {
  //     CheckOutObject checkOutObject = await FirebaseDataBaseService()
  //         .getCustomerSingleOrder(customerMyOrderObject.orderId);
  //     String basketId = customerRandomBasketValue;
  //
  //     checkOutObject.productsList.forEach((singleProduct) async {
  //       DatabaseReference dbf = firebaseDatabase
  //           .ref()
  //           .child('CustomerBaskets')
  //           .child(basketId)
  //           .child('basketInfo')
  //           .child(singleProduct.productId.toString());
  //
  //       await rootFirebaseIsExists(
  //         firebaseDatabase.ref().child('CustomerBaskets').child(basketId),
  //       ).then((value) async {
  //         if (value) {
  //           // print('i am Called again and value is $value');
  //         } else {
  //           DeviceInfoAndTimeObject deviceInfoAndTimeObject =
  //               await getDeviceInfoTime();
  //           Map<String, dynamic> deviceData = {
  //             'deviceInfo': deviceInfoAndTimeObject.deviceInfo,
  //             'timeInfo': deviceInfoAndTimeObject.timeInfo.toString(),
  //           };
  //
  //           await firebaseDatabase
  //               .ref()
  //               .child('CustomerBaskets')
  //               .child(basketId)
  //               .child('deviceInfo')
  //               .set(deviceData);
  //           // print('i am Called first time and value is $value');
  //         }
  //         Map<String, dynamic> basketData = {
  //           'itemId': singleProduct.productId,
  //           'itemUnitPrice':
  //               (singleProduct.productAmount - singleProduct.productDiscount),
  //           'quantity': singleProduct.quantity.toString(),
  //         };
  //         await dbf.set(basketData).then((basketUpdate) => {
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => CustomerViewBasketScreen(),
  //                 ),
  //               ),
  //             });
  //       });
  //     });
  //
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
//
//   Future<DeviceInfoAndTimeObject> getDeviceInfoTime() async {
//     DeviceInfoAndTimeObject deviceInfoAndTimeObject;
//
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       // print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
//
//       DateTime date = DateTime.now();
//       deviceInfoAndTimeObject = DeviceInfoAndTimeObject(
//         deviceInfo: 'Brand: ${androidInfo.brand}, Model: ${androidInfo.model}',
//         timeInfo: date,
//       );
//     } else if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       // print('Running on ${iosInfo.utsname.machine}');
//       DateTime date = DateTime.now();
//       deviceInfoAndTimeObject = DeviceInfoAndTimeObject(
//         deviceInfo: 'Name: ${iosInfo.name} Model${iosInfo.model}',
//         timeInfo: date,
//       );
//     }
//
//     return deviceInfoAndTimeObject;
//   }
//
  Future<bool> rootFirebaseIsExists(DatabaseReference databaseReference) async {
    DatabaseEvent snapshot = await databaseReference.once();
//    print(snapshot.value);
    return snapshot != null;
  }

  void showBottomSheet({@required RequestObject request}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return _sheetView(request: request);
        });
  }

  Widget _sheetView({@required RequestObject request}) {
    return Container(
      height: 535,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFC4C4C4),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            // 'Contact with the admin for more details',
            'Póngase en contacto con el\nadministrador para más detalles',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: dullFontColor,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            // 'Your chosen service',
            'Tu servicio elegido',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: pureBlackColor,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _singleSheetService(
            // title: 'Service',
            title: 'Servicio',
            value: request.requestType.details,
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Date',
            title: 'Fecha',
            value: DateFormat('yyyy-MM-dd').format(request.dateTime).toString(),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Date',
            title: 'Tiempo',
            value: MaterialLocalizations.of(context)
                .formatTimeOfDay(request.timeOfDay),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Hours',
            title: 'Horas',
            value: request.hours.toString(),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Area',
            title: 'Area',
            value: request.area.toString(),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Route',
            title: 'Ruta:',
            value: '${request.startingPoint} - ${request.endPoint}',
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Cost',
            title: 'Costo',
            value: '\$150 - \$200',
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Status',
            title: 'Estado',
            value: request.requestStatus,
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: MaterialButton(
              elevation: 10,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () => _openWhatsapp(phoneNumber: '+923493932069'),
              color: FOREGROUND_COLOR,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  // 'Contact',
                  'Contacto',
                  style: TEXT_STYLE_ON_FOREGROUND,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleSheetService({@required String title, @required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '$title:',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: dullFontColor,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: pureBlackColor,
            ),
          ),
        ),
      ],
    );
  }

  _openWhatsapp({@required String phoneNumber}) async {
    var whatsapp = phoneNumber;
    var whatsappURlAndroid = "https://wa.me/$whatsapp?text=${Uri.parse("")}";
    // "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      // if (await canLaunch(whatappURL_ios)) {
      await launch(whatappURLIos, forceSafariVC: false);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("whatsapp no installed")));
      // }
    } else {
      // android , web
      // if (await canLaunch(whatsappURl_android)) {
      await launch(whatsappURlAndroid);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("whatsapp no installed")));
      // }
    }
  }
}
