import 'dart:io';

import 'package:country_picker/country_picker.dart';

class CustomerObject {
  String customerUID,
      customerId,
      // userName,
      customerPhoneNumber,
      customerEmail,
      customerFirstName,
      customerLastName,
      customerPassword,
      customerImageName,
      customerImageLink,
      customerConfirmPassword,
      customerAddress,
      area,
      city;
  double weight, height;
  bool subscription;
  Country country;

  File customerImage;

  CustomerObject({
    this.customerUID,
    this.customerId,
    // this.userName,
    this.customerPhoneNumber,
    this.customerEmail,
    this.customerFirstName,
    this.customerLastName,
    this.customerPassword,
    this.customerAddress,
    this.customerImageLink,
    this.customerImageName,
    this.customerConfirmPassword,
    this.customerImage,
    this.height,
    this.weight,
    this.subscription,
    this.country,
    this.area,
    this.city,
  });

  String getCustomerName() {
    return '$customerFirstName $customerLastName';
  }
}
