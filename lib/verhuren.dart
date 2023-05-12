///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipark/chooseLocation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'custom_app_bar.dart';
import 'date_time_picker.dart';
import 'model/parking_spot_model.dart';

class Verhuren extends StatefulWidget {
  const Verhuren({super.key});

  @override
  State<Verhuren> createState() => _Verhuren();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: const CustomAppBar(
        title: "verhuren",
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
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
                hintText: "adres",
                filled: true,
                fillColor: Color(0xfff2f2f3),
                isDense: false,
                contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                suffixIcon:
                    Icon(Icons.search, color: Color(0xff212435), size: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child:

                  ///***If you have exported images you must have to copy those images in assets/images directory.
                  Image(
                image: AssetImage("assets/images/voorbeeldfotomap.png"),
                height: 100,
                width: 230,
                fit: BoxFit.cover,
              ),
            ),
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
                  },
                  color: Colors.blue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textColor: const Color(0xffffffff),
                  child: const Text(
                    "Of plaats een speld",
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
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
              padding: EdgeInsets.zero,
              width: MediaQuery.of(context).size.width * 0.8,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0x1f000000),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
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
                      child: DateTimePicker(setState: setFromDate),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const Text("tot:", textAlign: TextAlign.right),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: DateTimePicker(setState: setUntilDate),
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
    );
  }
}
