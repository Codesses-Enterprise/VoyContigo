import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voy_contigo/Objects/RequestTypeObject.dart';

void showNormalToast({@required String msg}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
      backgroundColor: const Color(0xff666666),
      textColor: Colors.white,
      fontSize: 16.0);
}

List<RequestTypeObject> requestTypes = [
  RequestTypeObject(
    key: '1',
    title: 'SERVICIO DE TRANSPORTACIÓN SOLAMENTE  ',
    details:
        'Consiste en recoger al pasajero (s) y llevarlo a su destino. (Tarifa: \$1.20 x milla).',
    rideFeeInMetro: 0.80,
    rideFeeOutMetro: 1.00,
    metroArea: '\$0.80/mile',
    ilsa: '\$1.00/mile',
    imageName: 'images/logo.png',
  ),

  // (Tarifa: $1.25 x milla + $20.00 p/h acompañamiento).
  RequestTypeObject(
    key: '2',
    title: 'SERVICIO DE TRANSPORTACIÓN CON CHOFER / ACOMPAÑANTE',
    details:
        ' Consiste en recoger al pasajero (s) y llevarlo a uno o varios lugares durante un período máximo de cuatro (4) horas. (Tarifa: \$1.25 x milla + \$20.00 p/h acompañamiento).',
    rideFeeInMetro: 25.00,
    rideFeeOutMetro: 30.00,
    metroArea: '\$25.00/mile',
    ilsa: '\$30.00/mile',
    imageName: 'images/logo.png',
  ),

  // (Tarifa: $1.25 x milla + $18.00 p/h acompañamiento).
  RequestTypeObject(
    key: '3',
    title: 'SERVICIO DE TRANSPORTACIÓN CON CHOFER / ACOMPAÑANTE',
    details:
        ' Consiste en recoger al pasajero (s) y llevarlo a uno o varios lugares durante un período de cinco (5) hasta ocho (8) horas. (Tarifa: \$1.25 x milla + \$18.00 p/h acompañamiento).',
    rideFeeInMetro: 40.00,
    rideFeeOutMetro: 50.00,
    metroArea: '\$40.00/mile',
    ilsa: '\$50.00/mile',
    imageName: 'images/logo.png',
  )
];

List<String> metroAreas = [
  'San Juan',
  'Bayamón',
  'Caguas',
  'Carolina',
  'Cataño',
  'Cayey',
  'Dorado',
  'Fajardo',
  'Guaynabo',
  'Trujillo Alto',
];

List<String> islaAreas = [
  'Añasco',
  'Arecibo',
  'Arroyo',
  'Barceloneta',
  'Barranquitas',
  'Cabo Rojo',
  'Camuy',
  'Canóvanas',
  'Ceiba',
  'Ciales',
  'Cidra',
  'Coamo',
  'Comerío',
  'Corozal',
  'Florida',
  'Guánica',
  'Guayama',
  'Guayanilla',
  'Gurabo',
  'Hatillo',
  'Hormigueros',
  'Humacao',
  'Isabela',
  'Jayuya',
  'Juana Díaz',
  'Juncos',
  'Lajas',
  'Lares',
  'Las Marías',
  'Las Piedras',
  'Loíza',
  'Luquillo',
  'Manatí',
  'Maricao',
  'Maunabo',
  'Mayagüez',
  'Moca',
  'Morovis',
  'Naguabo',
  'Naranjito',
  'Orocovis',
  'Patillas',
  'Peñuelas',
  'Ponce',
  'Quebradillas',
  'Rincón',
  'Río Grande',
  'Sabana Grande',
  'Salinas',
  'San Germán',
  'San Lorenzo',
  'San Sebastián',
  'Santa Isabel',
  'Toa Alta',
  'Toa Baja',
  'Utuado',
  'Vega Alta',
  'Vega Baja',
  'Villalba',
  'Yabucoa',
  'Yauco',
];
