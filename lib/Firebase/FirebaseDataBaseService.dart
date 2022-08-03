import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:voy_contigo/Objects/RequestObject.dart';
import 'package:voy_contigo/Objects/RequestTypeObject.dart';

import '../Objects/CustomerObject.dart';

class FirebaseDataBaseService {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future<bool> addNewCustomer({@required CustomerObject customer}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    final User currentUser = FirebaseAuth.instance.currentUser;
    String customerUID = currentUser.uid;

    // String imageName = customerObject.customerImage != null
    //     ? '$customerUID.${customerObject.customerImage.path.split('/').last.split('.').last}'
    //     : 'default';
    try {
      Map<String, dynamic> customerData = {
        'customerUID': customerUID,
        'customerFirstName': customer.customerFirstName,
        'customerLastName': customer.customerLastName,
        'customerImage': 'default.png',
        'customerEmail': customer.customerEmail.isNotEmpty
            ? customer.customerEmail
            : 'not avail',
        // 'country':
        //     '${customer.country.countryCode}_${customer.country.name}_${customer.country.phoneCode}_${customer.country.displayName}',
        'customerPhoneNumber': customer.customerPhoneNumber,
        'area': customer.area.toString(),
        'city': customer.city.toString(),
      };

      await dbf.child('Customers').child(customerUID).set(customerData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<CustomerObject> getSingleCustomer() async {
    try {
      CustomerObject customer;

      DatabaseReference dbf = firebaseDatabase
          .ref()
          .child('Customers')
          .child(FirebaseAuth.instance.currentUser.uid);
      // .child(FirebaseAuth.instance.currentUser.uid);

      await dbf.once().then((snapshot) {
        print(' Name Is${snapshot.snapshot.key}');
        Map<dynamic, dynamic> values = snapshot.snapshot.value;
        // print(' subscription ${values['userName']['title']}');
        // String supplierSequence = values['supplierSequence'].toString();

        customer = CustomerObject(
          customerUID: FirebaseAuth.instance.currentUser.uid,
          customerFirstName: values['customerFirstName'],
          customerLastName: values['customerLastName'],
          customerImageName: values['customerImage'],
          customerPhoneNumber: values['customerPhoneNumber'],
          customerId: values['customerUID'],
          customerEmail: values['customerEmail'],
          area: values['area'],
          city: values['city'],
          // country: Country(
          //   countryCode: values['country'].toString().split('_')[0],
          //   name: values['country'].toString().split('_')[1],
          //   phoneCode: values['country'].toString().split('_')[2],
          //   displayName: values['country'].toString().split('_')[1],
          // ),
        );
      });
      return customer;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> updateCustomer({@required CustomerObject customer}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    final User currentUser = FirebaseAuth.instance.currentUser;
    String customerUID = currentUser.uid;

    try {
      Map<String, dynamic> customerData = {
        'customerFirstName': customer.customerFirstName,
        'customerLastName': customer.customerLastName,
        'customerEmail': customer.customerEmail.isNotEmpty
            ? customer.customerEmail
            : 'not avail',
        // 'country':
        //     '${customer.country.countryCode}_${customer.country.name}_${customer.country.phoneCode}_${customer.country.displayName}',

        'area': customer.area.toString(),
        'city': customer.city.toString(),
      };

      await dbf.child('Customers').child(customerUID).update(customerData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> editCustomerProfilePicture(CustomerObject customerObject) async {
    DatabaseReference dbf = firebaseDatabase.ref();

    String imageName = customerObject.customerImage != null
        ? '${customerObject.customerUID}.${customerObject.customerImage.path.split('/').last.split('.').last}'
        : customerObject.customerImageName ?? 'default';
    try {
      Map<String, dynamic> customerData = {
        'customerImage': imageName,
      };

      final User currentUser = FirebaseAuth.instance.currentUser;

      String customerUID = currentUser.uid;
      await dbf.child('Customers').child(customerUID).update(customerData);

      return true;
    } catch (e) {
//      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> getPhoneNumberConfirm(String phoneNumber) async {
    bool find = false;
    DatabaseReference dbf = firebaseDatabase.reference().child('customers');

    await dbf.once().then((snapshot) {
      Map<dynamic, dynamic> value = snapshot.snapshot.value;
      if (value != null) {
        value.forEach((key, values) {
          if (values['customerPhoneNumber'] == phoneNumber) {
            find = true;
          }
        });
      }
    });

    return find;
  }

  Future<bool> addNewRideRequest({
    @required RequestObject request,
  }) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    final User currentUser = FirebaseAuth.instance.currentUser;
    String customerUID = currentUser.uid;

    String pushKey =
        dbf.child('CustomerRequests').child(customerUID).push().key;
    try {
      Map<String, dynamic> customerData = {
        'requestStatus': 'Pendiente',
        'key': request.key,
        'title': request.requestType.title,
        'details': request.requestType.details,
        'rideFeeInMetro': request.requestType.rideFeeInMetro,
        'rideFeeOutMetro': request.requestType.rideFeeOutMetro,
        // 'imageName': request.imageName,
        'dateTime': request.dateTime.toString(),
        'timeOfDay': '${request.timeOfDay.hour}:${request.timeOfDay.minute}',
        'hours': request.hours.toString(),
        'area': request.area.toString(),
        'startingPoint': request.startingPoint.toString(),
        'endPoint': request.endPoint.toString(),

        // 'timeOfDay': '${timeOfDay.hour}_${timeOfDay.minute}',
      };

      await dbf
          .child('CustomerRequests')
          .child(customerUID)
          .child(pushKey)
          .set(customerData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<List<RequestObject>> getMyOrders() async {
    List<RequestObject> requestsData = [];
    String customerUID = FirebaseAuth.instance.currentUser.uid;

    DatabaseReference dbf =
        firebaseDatabase.ref().child('CustomerRequests').child(customerUID);

    await dbf.once().then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.snapshot.value;
      if (values != null) {
        values.forEach((key, valueData) {
          RequestObject request = RequestObject(
            key: key,
            requestType: RequestTypeObject(
              key: valueData['key'],
              title: valueData['title'],
              details: valueData['details'],
              rideFeeInMetro:
                  double.parse(valueData['rideFeeInMetro'].toString()),
              rideFeeOutMetro:
                  double.parse(valueData['rideFeeOutMetro'].toString()),
              imageName: valueData['imageName'],
            ),
            dateTime: DateTime.parse(valueData['dateTime']),
            timeOfDay: TimeOfDay(
              hour: int.parse(
                valueData['timeOfDay'].toString().split(':').first,
              ),
              minute: int.parse(
                valueData['timeOfDay'].toString().split(':').last,
              ),
            ),
            hours: int.parse(
              valueData['hours'].toString(),
            ),
            area: valueData['area'],
            startingPoint: valueData['startingPoint'],
            endPoint: valueData['endPoint'],

            // timeOfDay: TimeOfDay(
            //     hour: int.parse(
            //         valueData['timeOfDay'].toString().split('_').first),
            //     minute: int.parse(
            //         valueData['timeOfDay'].toString().split('_').last)),
            requestStatus: valueData['requestStatus'],
          );
          requestsData.add(request);
        });
      }
    });

    return requestsData;
  }
}
