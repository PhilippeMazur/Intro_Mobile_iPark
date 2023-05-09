import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ipark/available_places/available_places_bottomscroller.dart';
import 'package:ipark/available_places/available_places_typebar.dart';
import 'package:ipark/model/parking_spot_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../custom_app_bar.dart';
import '../main.dart';
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

  late LatLng? userLocation;

  int currentIndex = 0;

  Distance distance = Distance();

  setNewAddress(LatLng newAddress) {
    setState(() {
      userLocation = newAddress;
      _data.sort((a, b) => distanceToUserLocation(a.coordinate)
          .compareTo(distanceToUserLocation(b.coordinate)));
      ;
    });
    if (userLocation != null) {
      animatedMapMove(userLocation!, _mapController.zoom);
    }
    logger.d(newAddress);
  }

  double distanceToUserLocation(GeoPoint databaseRecordPoint) {
    LatLng databaseRecordPointLatLng =
        LatLng(databaseRecordPoint.latitude, databaseRecordPoint.longitude);
    return distance.as(
        LengthUnit.Meter, databaseRecordPointLatLng, userLocation!);
  }

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
      if (userLocation != null) {
        newSpots.sort((a, b) => distanceToUserLocation(a.coordinate)
            .compareTo(distanceToUserLocation(b.coordinate)));
      }
      setState(() {
        _data = newSpots;
      });
    });

    super.initState();
    userLocation = null;
  }

  dragToParkingSpot(int index) {
    setState(() {
      currentIndex = index;
    });
    ParkingSpotModel spot = _data[index];
    if (spot.coordinate?.latitude != null &&
        spot.coordinate?.longitude != null) {
      LatLng center =
          LatLng(spot.coordinate!.latitude, spot.coordinate!.longitude);

      //replace
      animatedMapMove(center, _mapController.zoom);
    }
  }

  focusToListItem(int index) {
    print(index);
    setState(() {
      currentIndex = index;
    });
    bottomscrollerKey.currentState?.focusToItem(index);
  }

  animatedMapMove(LatLng destLocation, double destZoom) {
    //replace but because of bottomscroller
    double latitudeDistance =
        (_mapController.bounds!.north - _mapController.bounds!.south).abs();
    double offset = latitudeDistance / 7;

    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: _mapController.center.latitude,
        end: destLocation.latitude - offset);
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          AvailablePlacesMap(
            availablePlaces: _data,
            mapController: _mapController,
            snapToFunction: focusToListItem,
            userLocation: userLocation,
            scrollbarIndex: currentIndex,
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: AvailablePlacesBottomscroller(
                availablePlaces: _data,
                dragToParkingSpot: dragToParkingSpot,
                snaplistKey: bottomscrollerKey,
                userLocation: userLocation,
              )),
          AvailablePlacesTypeBar(changeChosenAddress: setNewAddress),
        ],
      ),
    );
  }
}
