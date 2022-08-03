import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voy_contigo/Firebase/FirebaseDataBaseService.dart';
import 'package:voy_contigo/Objects/RequestObject.dart';
import 'package:voy_contigo/Objects/RequestTypeObject.dart';
import 'package:voy_contigo/Screen/HomeScreen.dart';
import 'package:voy_contigo/Utils/Colors.dart';
import 'package:voy_contigo/Utils/Constents.dart';
import 'package:voy_contigo/Utils/Global.dart';
import 'package:voy_contigo/Utils/validators.dart';

class SubmitRequestScreen extends StatefulWidget {
  final RequestTypeObject requestType;

  const SubmitRequestScreen({Key key, @required this.requestType})
      : super(key: key);
  @override
  _SubmitRequestScreenState createState() =>
      _SubmitRequestScreenState(requestType: requestType);
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen> {
  TextEditingController selectedDateTextController = TextEditingController();
  TextEditingController selectedTimeTextController = TextEditingController();

  final RequestTypeObject requestType;
  _SubmitRequestScreenState({@required this.requestType});

  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  RequestObject _request = RequestObject();

  bool buttonLoading = false;

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime.now(),
            //what will be the previous supported year in picker
            lastDate: DateTime.now().add(const Duration(
                days: 15))) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
        selectedDateTextController.text =
            DateFormat('yyyy-MM-dd').format(_selectedDate).toString();
        _request.dateTime = _selectedDate;
      });
    });
  }

  void _pickTimeDialog() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ) //what will be the up to supported date in picker
        .then((pickedTimeData) {
      //then usually do the future job
      if (pickedTimeData == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedTime = pickedTimeData;
        selectedTimeTextController.text =
            MaterialLocalizations.of(context).formatTimeOfDay(_selectedTime);
        _request.timeOfDay = _selectedTime;
      });
    });
  }

  @override
  void initState() {
    _request.requestType = requestType;

    super.initState();
  }

  final GlobalKey<FormState> _submitRequestFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casa'),
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: pureWhiteColor,
      padding: const EdgeInsets.all(25),
      child: Form(
        key: _submitRequestFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                // 'Fill out the service form',
                'CONFIRME LOS DATOS DEL SERVICIO:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: themeBlackColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                child: GestureDetector(
                  onTap: () => _pickDateDialog(),
                  child: TextFormField(
                    controller: selectedDateTextController,
                    keyboardType: TextInputType.datetime,

                    decoration: const InputDecoration(
                      // labelText: 'CHOOSE DATE*',
                      labelText: 'ELEGIR FECHA *',
                      labelStyle: labelTextStyle,
                      enabled: false,
                      contentPadding: EdgeInsets.all(0),
                      border: UnderlineInputBorder(
                          // borderSide: BorderSide(color: Colors.cyan),
                          ),
                    ),
                    validator: (dateTime) =>
                        requiredField(dateTime, 'ELEGIR FECHA'),
                    // onSaved: (customerFirstName) =>
                    // _request.dateTime.customerFirstName = customerFirstName,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                child: GestureDetector(
                  onTap: () => _pickTimeDialog(),
                  child: TextFormField(
                    controller: selectedTimeTextController,
                    keyboardType: TextInputType.datetime,

                    decoration: const InputDecoration(
                      // labelText: 'CHOOSE DATE*',
                      labelText: 'TIEMPO *',

                      labelStyle: labelTextStyle,
                      enabled: false,
                      contentPadding: EdgeInsets.all(0),
                      border: UnderlineInputBorder(
                          // borderSide: BorderSide(color: Colors.cyan),
                          ),
                    ),
                    validator: (dateTime) => requiredField(dateTime, 'TIEMPO'),
                    // onSaved: (customerFirstName) =>
                    // _request.dateTime.customerFirstName = customerFirstName,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                child: TextFormField(
                  // controller: firstNameTextController,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  decoration: const InputDecoration(
                    counterText: '',
                    // labelText: 'NO OF HOURS*',
                    labelText: 'NO DE HORAS *',
                    labelStyle: labelTextStyle,
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(
                        // borderSide: BorderSide(color: Colors.cyan),
                        ),
                  ),
                  validator: (hours) => requiredField(hours, 'HORAS'),
                  onSaved: (hours) => _request.hours = int.parse(hours),
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
                      value: _request.area,
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
                          _request.area = area;
                        });
                      },
                    ),
                  ],
                ),
                // TextFormField(
                //   // controller: firstNameTextController,
                //   keyboardType: TextInputType.streetAddress,
                //   decoration: const InputDecoration(
                //     labelText: 'AREA*',
                //     labelStyle: labelTextStyle,
                //     contentPadding: EdgeInsets.all(0),
                //     border: UnderlineInputBorder(
                //         // borderSide: BorderSide(color: Colors.cyan),
                //         ),
                //   ),
                //   validator: (area) => requiredField(area, 'Area'),
                //   onSaved: (area) => _request.area = area,
                // ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PUNTO DE PARTIDA *',
                      style: labelTextStyle,
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _request.startingPoint,
                      items: _request.area == 'METRO'
                          ? metroAreas.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : islaAreas.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      onChanged: (startingPoint) {
                        setState(() {
                          _request.startingPoint = startingPoint;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PUNTO DE PARTIDA *',
                      style: labelTextStyle,
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _request.endPoint,
                      items: _request.area == 'METRO'
                          ? metroAreas.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : islaAreas.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      onChanged: (endPoint) {
                        setState(() {
                          _request.endPoint = endPoint;
                        });
                      },
                    ),
                  ],
                ),
                // TextFormField(
                //   // controller: firstNameTextController,
                //   keyboardType: TextInputType.name,
                //   decoration: const InputDecoration(
                //     // labelText: 'DESTINATION',
                //     labelText: 'DESTINO *',
                //     labelStyle: labelTextStyle,
                //     contentPadding: EdgeInsets.all(0),
                //     border: UnderlineInputBorder(
                //         // borderSide: BorderSide(color: Colors.cyan),
                //         ),
                //   ),
                //   validator: (endPoint) => requiredField(endPoint, 'DESTINO'),
                //   onSaved: (endPoint) => _request.endPoint = endPoint,
                // ),
              ),
              submitRequestButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitRequestButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        elevation: 10,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => {
          if (!buttonLoading)
            {
              if (_request.requestType != null)
                {
                  if (_selectedDate != null &&
                      _request.area != null &&
                      _request.startingPoint != null &&
                      _request.endPoint != null)
                    {
                      if (_submitRequestFormKey.currentState.validate())
                        {
                          _submitRequestFormKey.currentState.save(),
                          showBottomSheet(),
                        },
                    }
                }
            }
        },
        color: FOREGROUND_COLOR,
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            'Continuar',
            style: TEXT_STYLE_ON_FOREGROUND,
          ),
        ),
      ),
    );
  }

  Widget _sheetView() {
    return Container(
      height: 460,
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
            // 'Please confirm your services',
            'Por favor confirme sus servicios',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: dullFontColor,
            ),
          ),
          const SizedBox(
            height: 35,
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
            height: 25,
          ),
          _singleSheetService(
            // title: 'Service',
            title: 'Servicio',
            value: _request.requestType.title,
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Date',
            title: 'Fecha',
            value:
                DateFormat('yyyy-MM-dd').format(_request.dateTime).toString(),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Date',
            title: 'Tiempo',
            value: MaterialLocalizations.of(context)
                .formatTimeOfDay(_request.timeOfDay),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Hours',
            title: 'Horas',
            value: _request.hours.toString(),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Area',
            title: 'Área',
            value: _request.area.toString(),
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Route',
            title: 'Ruta',
            value: '${_request.startingPoint} - ${_request.endPoint}',
          ),
          const SizedBox(
            height: 15,
          ),
          _singleSheetService(
            // title: 'Cost',
            title: 'Costo',
            value: '\$150 - \$200',
          ),
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 25),
            child: MaterialButton(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () => _submitRequest(),
              color: FOREGROUND_COLOR,
              height: 50,
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
                        // 'Confirm',
                        'Confirmar',
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

  void showBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return _sheetView();
        });
  }

  Future<void> _submitRequest() async {
    if (!buttonLoading) {
      try {
        if (_request.requestType != null) {
          if (_selectedDate != null) {
            if (_submitRequestFormKey.currentState.validate()) {
              _submitRequestFormKey.currentState.save();
              setState(() {
                buttonLoading = true;
              });

              await FirebaseDataBaseService()
                  .addNewRideRequest(
                    request: _request,
                  )
                  .then((value) => {
                        if (value != null)
                          {
                            showNormalToast(msg: 'Request Submitted!'),
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(
                                    fromEditProfile: true,
                                  ),
                                ),
                                (route) => false),
                          }
                      });
            } else {
              showNormalToast(msg: 'Select Time First');
            }
          } else {
            showNormalToast(msg: 'Select Date First');
          }
        } else {
          showNormalToast(msg: 'Select Request Type First');
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          buttonLoading = false;
        });
      } finally {
        setState(() {
          buttonLoading = false;
        });
      }
    }
  }
}
