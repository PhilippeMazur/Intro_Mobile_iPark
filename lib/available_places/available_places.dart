import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ipark/available_places/available_places_bottomscroller.dart';
import 'package:ipark/available_places/available_places_typebar.dart';
import 'package:ipark/model/parking_spot_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'available_places_map.dart';

class AvailablePlaces extends StatefulWidget {
  const AvailablePlaces({super.key});

  @override
  State<AvailablePlaces> createState() => _AvailablePlacesState();
}

class _AvailablePlacesState extends State<AvailablePlaces>
    with TickerProviderStateMixin {
  final AvailablePlacesSnapshot =
      FirebaseFirestore.instance.collection("parking_spots").snapshots();
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _streamSubscription;

  late final MapController _mapController;

  List<ParkingSpotModel> _data = [];

  List<int> data = [];

  final GlobalKey<ScrollSnapListState> bottomscrollerKey = GlobalKey();

  @override
  void initState() {
    _mapController = MapController();
    _streamSubscription = AvailablePlacesSnapshot.listen((data) {
      List<ParkingSpotModel> newSpots = [];
      for (var map in data.docs) {
        try {
          var spot = ParkingSpotModel.fromMap(map.data());
          newSpots.add(spot);
        } catch (e) {
          print('Skipping object');
        }
      }
      setState(() {
        _data = newSpots;
      });
    });
    super.initState();
  }

  dragToParkingSpot(int index) {
    print(index);
    ParkingSpotModel spot = _data[index];
    if (spot.coordinate?.latitude != null &&
        spot.coordinate?.longitude != null) {
      LatLng center =
          LatLng(spot.coordinate!.latitude, spot.coordinate!.longitude);
      print(center);
      animatedMapMove(center, _mapController.zoom);
    }
  }

  focusToListItem(int index) {
    print(index);
    bottomscrollerKey.currentState?.focusToItem(index);
  }

  animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    print(_data);
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff212435),
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          AvailablePlacesMap(
            availablePlaces: _data,
            mapController: _mapController,
            snapToFunction: focusToListItem,
          ),
          AvailablePlacesTypeBar(),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: AvailablePlacesBottomscroller(
                availablePlaces: _data,
                dragToParkingSpot: dragToParkingSpot,
                snaplistKey: bottomscrollerKey,
              )),
        ],
      ),
    );
  }
}
