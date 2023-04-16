import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipark/available_places/available_places_bottomscroller.dart';
import 'package:ipark/available_places/available_places_typebar.dart';

import 'available_places_map.dart';

class AvailablePlaces extends StatefulWidget {
  const AvailablePlaces({super.key});

  @override
  State<AvailablePlaces> createState() => _AvailablePlacesState();
}

class _AvailablePlacesState extends State<AvailablePlaces> {
  final availablePlacesDB =
      FirebaseFirestore.instance.collection("parking_spots");

  List<int> data = [];

  @override
  void initState() {
    for (int i = 0; i < 30; i++) {
      data.add(Random().nextInt(100) + 1);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Color.fromARGB(255, 255, 255, 255),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: const Border(
            bottom:
                BorderSide(color: Color.fromARGB(255, 0, 152, 217), width: 4)),
        title: const Text(
          "Choose spot",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xff000000),
          ),
        ),
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xff212435),
          size: 24,
        ),
      ),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          AvailablePlacesMap(),
          AvailablePlacesTypeBar(),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: AvailablePlacesBottomscroller(data: data)),
        ],
      ),
    );
  }
}