import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ipark/verhuren.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class ChooseLocation extends StatefulWidget {
  final Function(String) setAddress;
  final Function(GeoPoint) setGeoPoint;
  const ChooseLocation(
      {super.key, required this.setAddress, required this.setGeoPoint});

  @override
  State<ChooseLocation> createState() => _ChooseLocation();
}

class _ChooseLocation extends State<ChooseLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies een locatie'),
      ),
      body: Container(
        child: OpenStreetMapSearchAndPick(
            center: LatLong(51.260197, 4.402771),
            buttonColor: Color.fromARGB(255, 8, 73, 171),
            buttonText: 'Zet huidige locatie',
            onPicked: (pickedData) {
              List<String> addressParts = pickedData.address.split(",");
              widget.setAddress(
                  "${addressParts[1]} ${addressParts[0]}, ${addressParts[4]} ${addressParts[2]}");
              widget.setGeoPoint(GeoPoint(
                  pickedData.latLong.latitude, pickedData.latLong.longitude));
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => Verhuren()),
              );
            }),
      ),
    );
  }
}

void ShowModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          color: Colors.red,
          child: Center(
            child: Text("Hello"),
          ),
        );
      });
}
