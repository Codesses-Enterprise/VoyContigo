import 'package:flutter/material.dart';
import 'package:voy_contigo/Objects/RequestTypeObject.dart';

class RequestObject {
  String key;
  RequestTypeObject requestType;
  DateTime dateTime;
  TimeOfDay timeOfDay;
  int hours;
  double cost;
  String requestStatus, area, startingPoint, endPoint;

  RequestObject({
    this.key,
    this.requestType,
    this.dateTime,
    this.hours,
    this.timeOfDay,
    this.requestStatus,
    this.area,
    this.cost,
    this.endPoint,
    this.startingPoint,
  });
}
