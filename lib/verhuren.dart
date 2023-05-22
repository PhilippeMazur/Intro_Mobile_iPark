import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ipark/chooseLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'custom_app_bar.dart';
import 'date_time_picker.dart';
import 'model/parking_spot_model.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;

class Verhuren extends StatefulWidget {
  const Verhuren({super.key});

  static final MapController mapController = MapController();

  @override
  State<Verhuren> createState() => _Verhuren();
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Succesfull'),
        content: const Text('Your session has been started !'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _Verhuren extends State<Verhuren> {
  String size = "not specified";
  GeoPoint geopoint = GeoPoint(0, 0);
  final TextEditingController vanController = TextEditingController();
  final TextEditingController totController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late final DateTime fromDate;
  late final DateTime untilDate;

  double scrollHeight = 750;
  bool _isTextFieldFocused = false;
  ScrollController _scrollController = ScrollController();
  String geoLocatie = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  setAddress(String newAddress) {
    _addressController.text = newAddress;
  }

  setGeoPoint(GeoPoint newGeopoint) {
    setState(() {
      geopoint = newGeopoint;
    });
  }

  setSize(String newSize) {
    setState(() {
      size = newSize;
    });
  }

  setFromDate(DateTime newFromDate) {
    setState(() {
      fromDate = newFromDate;
    });
  }

  setUntilDate(DateTime newUntilDate) {
    setState(() {
      untilDate = newUntilDate;
    });
  }

  Future<void> saveData() async {
    await FirebaseFirestore.instance.collection("parking_spots").add(
        ParkingSpotModel(
                coordinate: geopoint,
                from: Timestamp.fromMillisecondsSinceEpoch(
                    fromDate.millisecondsSinceEpoch),
                size: sizeController.text,
                until: Timestamp.fromMillisecondsSinceEpoch(
                    untilDate.millisecondsSinceEpoch),
                user_uid: auth.currentUser!.uid)
            .toMap());
  }

  Future<void> requestLocationPermission() async {
    var locatie = loc.Location();

    final permissionStatus = await locatie.requestPermission();
    if (permissionStatus == loc.PermissionStatus.denied) {
      // Permission was denied by the user, handle it accordingly
      print('Location permission denied');
    } else if (permissionStatus == loc.PermissionStatus.deniedForever) {
      // Permission was permanently denied, take appropriate action
      print('Location permission permanently denied');
    } else {
      // Permission granted, you can proceed with location operations
      print('Location permission granted');
      setState(() {});
    }
  }

  void jumpToLocation(LatLng location) {
    Verhuren.mapController.move(location, Verhuren.mapController.zoom);
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      final address = decodedResponse['display_name'] as String;
      return address;
    }

    return null; // Return null if the geocoding request fails
  }

  void getCurrentLocation() async {
    requestLocationPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Current location: ${position.latitude}, ${position.longitude}');
      final address = await getAddressFromCoordinates(
          position.latitude, position.longitude);
      geoLocatie = address.toString();
      setGeoPoint(new GeoPoint(position.latitude, position.longitude));
      jumpToLocation(LatLng(position.latitude, position.longitude));
      //geopoint = GeoPoint(position.latitude, position.longitude);
      _addressController.text = address.toString();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: const CustomAppBar(
        title: "verhuren",
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            height: scrollHeight,
            child: Column(
              children: [
                TextField(
                  readOnly: true,
                  controller: _addressController,
                  obscureText: false,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.all(Radius.circular(90.0)),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color.fromARGB(255, 129, 129, 129),
                    ),
                    hintText:
                        "Maak een keuze (Gebruik huidige locatie/Plaats een speld)",
                    filled: true,
                    fillColor: Color(0xfff2f2f3),
                    isDense: false,
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 200,
                    width: 350,
                    child: FlutterMap(
                      mapController: Verhuren.mapController,
                      options: MapOptions(
                        minZoom: 15.0,
                        maxZoom: 15.0,
                        center: LatLng(51.260197,
                            4.40277), // Set the initial map center coordinates
                        zoom: 15.0, // Set the initial zoom level
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'http://mt{s}.google.com/vt/x={x}&y={y}&z={z}', // Map provider URL
                          subdomains: const ['1', '2', '3'],
                          retinaMode: true,
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point:
                                  LatLng(geopoint.latitude, geopoint.longitude),
                              builder: (context) => GestureDetector(
                                  child: Image.asset(
                                      "assets/images/mapMarker.png")),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: MaterialButton(
                      onPressed: () {
                        getCurrentLocation();
                      },
                      color: Colors.blue,
                      minWidth: 500,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textColor: Color(0xffffffff),
                      child: const Text(
                        "Gebruik huidige locatie",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )),
                Row(children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseLocation(
                                  setAddress: setAddress,
                                  setGeoPoint: setGeoPoint)),
                        );
                        jumpToLocation(
                            LatLng(geopoint.latitude, geopoint.longitude));
                      },
                      color: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textColor: const Color(0xffffffff),
                      child: const Text(
                        "Plaats een speld",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  )
                ]),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  padding: EdgeInsets.zero,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0x1f000000),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.zero,
                    border:
                        Border.all(color: const Color(0x4d9e9e9e), width: 1),
                  ),
                ),
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        const Text("van:", textAlign: TextAlign.right),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: DateTimePicker(
                            setState: setFromDate,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90.0)),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color.fromARGB(255, 129, 129, 129),
                              ),
                              hintText: "datum",
                              filled: true,
                              fillColor: Color(0xfff2f2f3),
                              isDense: false,
                              contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              suffixIcon: Icon(Icons.calendar_today,
                                  color: Color(0xff212435), size: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        const Text("tot:", textAlign: TextAlign.right),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: DateTimePicker(
                            setState: setUntilDate,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90.0)),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color.fromARGB(255, 129, 129, 129),
                              ),
                              hintText: "datum",
                              filled: true,
                              fillColor: Color(0xfff2f2f3),
                              isDense: false,
                              contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              suffixIcon: Icon(Icons.calendar_today,
                                  color: Color(0xff212435), size: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        const Text("grootte:", textAlign: TextAlign.right),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: TextField(
                            controller: sizeController,
                            obscureText: false,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12,
                              color: Color(0xff000000),
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90.0)),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color.fromARGB(255, 129, 129, 129),
                              ),
                              hintText: "Klein - Medium - Groot",
                              filled: true,
                              fillColor: Color(0xfff2f2f3),
                              isDense: false,
                              contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              suffixIcon: Icon(Icons.switch_left_rounded,
                                  color: Color(0xff212435), size: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              saveData();
                              _dialogBuilder(context);
                            },
                            color: Colors.blue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textColor: const Color(0xffffffff),
                            child: const Text(
                              "START SESSIE",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
