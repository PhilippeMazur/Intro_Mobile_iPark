import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ipark/search_and_pic.dart';
import 'package:ipark/verhuren.dart';
import 'package:latlong2/latlong.dart';

import 'custom_app_bar.dart';

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
      appBar: const CustomAppBar(
        title: "Kies een locatie",
      ),
      body: SearchAndPick(
          center: LatLng(51.260197, 4.402771),
          buttonColor: Colors.blue,
          buttonText: 'Zet huidige locatie',
          onPicked: (pickedData) {
            List<String> addressParts = pickedData.address.split(",");
            widget.setAddress(
                "${addressParts[1]} ${addressParts[0]}, ${addressParts[4]} ${addressParts[2]}");
            widget.setGeoPoint(GeoPoint(
                pickedData.latLong.latitude, pickedData.latLong.longitude));
            Navigator.pop(
              context,
            );
          }),
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
