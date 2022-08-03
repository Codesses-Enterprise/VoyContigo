import 'package:flutter/material.dart';
import 'package:voy_contigo/Firebase/FirebaseDataBaseService.dart';
import 'package:voy_contigo/Objects/CustomerObject.dart';
import 'package:voy_contigo/Objects/RequestTypeObject.dart';
import 'package:voy_contigo/Screen/SubmitRequestScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';
import 'package:voy_contigo/Utils/Global.dart';

class BookOrderScreen extends StatefulWidget {
  @override
  _BookOrderScreenState createState() => _BookOrderScreenState();
}

class _BookOrderScreenState extends State<BookOrderScreen> {
  CustomerObject _customer;

  TextEditingController selectedDateTextController = TextEditingController();
  TextEditingController selectedTimeTextController = TextEditingController();
  bool buttonLoading = false;

  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  RequestTypeObject _selectedRequest;

  Future<void> getCustomer() async {
    CustomerObject customerObject =
        await FirebaseDataBaseService().getSingleCustomer();

    if (customerObject != null) {
      setState(() {
        _customer = customerObject;
      });
    }
  }

  @override
  void initState() {
    getCustomer();
    _selectedRequest = requestTypes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casa'),
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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(25),
      color: pureWhiteColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              // 'Choose a Service that you need',
              'Elige un Servicio que necesites',
              style: TextStyle(
                color: pureBlackColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _singleServiceView(
              requestType: requestTypes[0],
            ),
            _singleServiceView(
              requestType: requestTypes[1],
            ),
            _singleServiceView(
              requestType: requestTypes[2],
            ),
            // Expanded(
            //   flex: 4,
            //   child: Swiper(
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (BuildContext context, int index) {
            //       return _buildSwiperList(requestTypes[index], index);
            //     },
            //     onIndexChanged: (index) => {
            //       setState(() {
            //         _selectedRequest = requestTypes[index];
            //       })
            //     },
            //     itemCount: requestTypes.length,
            //     pagination: const SwiperPagination(),
            //     layout: SwiperLayout.DEFAULT,
            //   ),
            // // ),
            // Expanded(
            //   flex: 6,
            //   child: Column(
            //     children: [
            //       GestureDetector(
            //         onTap: () => _pickDateDialog(),
            //         child: Container(
            //           margin: const EdgeInsets.only(
            //             top: 10,
            //           ),
            //           decoration: BoxDecoration(
            //               color: backgroundColor,
            //               borderRadius: BorderRadius.circular(10),
            //               border: Border.all(color: grayColor, width: 2)),
            //           child: TextFormField(
            //             enabled: false,
            //             controller: selectedDateTextController,
            //             decoration: const InputDecoration(
            //               labelText: 'Chose Date',
            //               contentPadding: EdgeInsets.all(10),
            //               border: InputBorder.none,
            //             ),
            //             // validator: (country) => validatePhoneNumber(country),
            //             // onSaved: (country) => loginUserObject.country = country,
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: () async => {
            //           await showTimePicker(
            //             initialTime: TimeOfDay.now(),
            //             context: context,
            //           ).then((picked) => {
            //                 if (picked != null && picked != TimeOfDay.now())
            //                   {
            //                     setState(() {
            //                       _selectedTime = picked;
            //                       selectedTimeTextController.text = picked
            //                           .format(context)
            //                           .toString(); //I'm using intl package, you can use toString()
            //                     })
            //                   }
            //               }),
            //         },
            //         child: Container(
            //           margin: const EdgeInsets.only(
            //             top: 10,
            //           ),
            //           decoration: BoxDecoration(
            //               color: backgroundColor,
            //               borderRadius: BorderRadius.circular(10),
            //               border: Border.all(color: grayColor, width: 2)),
            //           child: TextFormField(
            //             enabled: false,
            //             controller: selectedTimeTextController,
            //             decoration: const InputDecoration(
            //               labelText: 'Chose Time',
            //               contentPadding: EdgeInsets.all(10),
            //               border: InputBorder.none,
            //             ),
            //             // validator: (country) => validatePhoneNumber(country),
            //             // onSaved: (country) => loginUserObject.country = country,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            buildRequestButton()
          ],
        ),
      ),
    );
  }

  // Widget _buildSwiperList(RequestTypeObject request, int index) {
  //   return Card(
  //     elevation: 4.0,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //       side: BorderSide(width: 2, color: grayColor),
  //     ),
  //     child: Container(
  //       padding: const EdgeInsets.all(10),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Image.asset(
  //             //   request.imageName,
  //             //   fit: BoxFit.fill,
  //             // ),
  //             Text(
  //               request.title,
  //               style: const TextStyle(
  //                   color: orangeColor,
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(
  //               height: 15,
  //             ),
  //             _singleServiceView(),
  //             // const Text(
  //             //   'Details:',
  //             //   style: TextStyle(
  //             //       color: pureBlackColor,
  //             //       fontSize: 16,
  //             //       fontWeight: FontWeight.bold),
  //             // ),
  //             // Text(
  //             //   request.details,
  //             //   style: const TextStyle(
  //             //       color: grayColor,
  //             //       fontSize: 16,
  //             //       fontWeight: FontWeight.normal),
  //             // ),
  //             // const SizedBox(
  //             //   height: 15,
  //             // ),
  //             const Text(
  //               'Ride Fee:',
  //               style: TextStyle(
  //                   color: pureBlackColor,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 20),
  //               child: Text(
  //                 'In aMetro Area = ${request.rideFeeInMetro} and out Of Metro = ${request.rideFeeOutMetro}',
  //                 style: const TextStyle(
  //                     color: grayColor,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.normal),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 15,
  //             ),
  //             const Text(
  //               'Safety Fee:',
  //               style: TextStyle(
  //                   color: pureBlackColor,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.only(left: 20),
  //               child: Text(
  //                 'Not Define',
  //                 style: TextStyle(
  //                     color: grayColor,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.normal),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _singleServiceView({@required RequestTypeObject requestType}) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          _selectedRequest = requestType;
        })
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: pureBlackColor,
            width: 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              _selectedRequest.key == requestType.key
                  ? 'images/radio_active.png'
                  : 'images/radio_inactive.png',
              width: 21,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requestType.title,
                    style: const TextStyle(
                      color: pureBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    requestType.details,
                    style: const TextStyle(
                      color: pureBlackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // Row(
                  //   children: [
                  //     const Text(
                  //       'Metro Area: ',
                  //       style: TextStyle(
                  //         color: pureBlackColor,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //     Text(
                  //       requestType.metroArea,
                  //       style: const TextStyle(
                  //         color: pureBlackColor,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   children: [
                  //     const Text(
                  //       'ILSA: ',
                  //       style: TextStyle(
                  //         color: pureBlackColor,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //     Text(
                  //       requestType.ilsa,
                  //       style: const TextStyle(
                  //         color: pureBlackColor,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRequestButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        elevation: 10,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubmitRequestScreen(
              requestType: _selectedRequest,
            ),
          ),
        ),
        color: FOREGROUND_COLOR,
        child: Container(
          alignment: Alignment.center,
          child: const Text('Continuar', style: TEXT_STYLE_ON_FOREGROUND),
        ),
      ),
    );
  }
}
