// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/account.dart';
import '../model/parking_spot_model.dart';

class AvailablePlacesBottomscroller extends StatefulWidget {
  final List<ParkingSpotModel> availablePlaces;
  final Function(int) dragToParkingSpot;
  final GlobalKey<ScrollSnapListState>? snaplistKey;
  final LatLng? userLocation;

  const AvailablePlacesBottomscroller(
      {super.key,
      required this.availablePlaces,
      required this.dragToParkingSpot,
      this.snaplistKey,
      required this.userLocation});

  @override
  State<AvailablePlacesBottomscroller> createState() =>
      _AvailablePlacesBottomscrollerState();
}

class _AvailablePlacesBottomscrollerState
    extends State<AvailablePlacesBottomscroller> {
  final Distance distance = Distance();
  @override
  void initState() {
    super.initState();
  }

  void _onItemFocus(int index) {
    setState(() {
      widget.dragToParkingSpot(index);
    });
  }

  Future<Account?> getAccount(String userUid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .where('user_uid', isEqualTo: userUid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final account = Account.fromMap(
          querySnapshot.docs.first.data(),
        );
        logger.d(account);
        return account;
      } else {
        logger.e("user not found");
        return null;
      }
    } catch (e) {
      logger.e("something went wrong");
      return null;
    }
  }

  Future<dynamic> fetchJson(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);

    // If the file exists in the cache, read and return it as JSON
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      //logger.d("request from cache");
      return json.decode(jsonString);
    }

    // If the file doesn't exist in the cache, fetch it and save it to the cache
    final response = await http.get(Uri.parse(url));
    final jsonData = response.bodyBytes;

    await DefaultCacheManager().putFile(
      url,
      Uint8List.fromList(jsonData),
    );

    return json.decode(utf8.decode(jsonData));
  }

  String distanceToUserLocation(GeoPoint databaseRecordPoint) {
    LatLng databaseRecordPointLatLng =
        LatLng(databaseRecordPoint.latitude, databaseRecordPoint.longitude);
    double distanceMeters = distance.as(
        LengthUnit.Meter, databaseRecordPointLatLng, widget.userLocation!);
    return (distanceMeters / 1000).toStringAsFixed(3);
  }

  Future<dynamic> getAddressFromGeoPoint(GeoPoint geoPoint) async {
    // Construct the Nominatim API URL
    final apiUrl =
        'https://nominatim.openstreetmap.org/reverse?lat=${geoPoint.latitude}&lon=${geoPoint.longitude}&format=json&addressdetails=1';

    // Make an HTTP request to the Nominatim API
    final response = await fetchJson(apiUrl);

    // Parse the response body to extract the address
    //final json = jsonDecode(response);
    return response;
  }

  String formatAdress(dynamic nominatimResponse) {
    dynamic address = nominatimResponse["address"];
    if (address == null) return "error";
    String townOrCity = address["town"] ?? address["city"];
    return '${address["road"] ?? ""} ${address["house_number"] ?? ""}, ${address["postcode"] ?? ""} $townOrCity';
  }

  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget.userLocation != null)
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
              child: Text(
                "${distanceToUserLocation(widget.availablePlaces[index].coordinate)} km",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                Expanded(
                    child: FutureBuilder(
                  future: getAddressFromGeoPoint(
                      widget.availablePlaces[index].coordinate),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                        "er ging iets mis",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else if (snapshot.hasData) {
                      return Text(
                        formatAdress(snapshot.data),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return const Text("loading");
                    }
                  },
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                Expanded(
                    child: FutureBuilder<Account?>(
                  future: getAccount(widget.availablePlaces[index].user_uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final account = snapshot.data;
                      if (account != null) {
                        return Text(
                          account.username,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else {
                        return const Text(
                          'User not found',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    } else {
                      return const Text(
                        'loading...',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  },
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.switch_left_rounded,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                Expanded(
                    child: Text(
                  widget.availablePlaces[index].size,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: const Icon(Icons.confirmation_num)),
                      const Text("CONFIRM")
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Colors.transparent,
      child: ScrollSnapList(
        clipBehavior: Clip.none,
        margin: const EdgeInsets.only(bottom: 30),
        onItemFocus: _onItemFocus,
        itemSize: 260,
        itemBuilder: _buildListItem,
        dynamicItemSize: true,
        dynamicSizeEquation: (distance) => 1 - min(distance.abs() / 500, 0.2),
        itemCount: widget.availablePlaces.length,
        key: widget.snaplistKey,
      ),
    );
  }
}
