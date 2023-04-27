import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;

import '../model/parking_spot_model.dart';

class AvailablePlacesBottomscroller extends StatefulWidget {
  final List<ParkingSpotModel> availablePlaces;
  final Function(int) dragToParkingSpot;
  final GlobalKey<ScrollSnapListState>? snaplistKey;

  const AvailablePlacesBottomscroller(
      {super.key,
      required this.availablePlaces,
      required this.dragToParkingSpot,
      this.snaplistKey});

  @override
  State<AvailablePlacesBottomscroller> createState() =>
      _AvailablePlacesBottomscrollerState();
}

class _AvailablePlacesBottomscrollerState
    extends State<AvailablePlacesBottomscroller> {
  @override
  void initState() {
    super.initState();
  }

  void _onItemFocus(int index) {
    setState(() {
      widget.dragToParkingSpot(index);
    });
  }

  Future<dynamic> fetchJson(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);

    // If the file exists in the cache, read and return it as JSON
    if (await file.exists()) {
      final jsonString = await file.readAsString();
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

  Future<dynamic> getAddressFromGeoPoint(GeoPoint geoPoint) async {
    // Construct the Nominatim API URL
    final apiUrl =
        'https://nominatim.openstreetmap.org/reverse?lat=${geoPoint.latitude}&lon=${geoPoint.longitude}&format=json&addressdetails=1';

    // Make an HTTP request to the Nominatim API
    final response = await fetchJson(apiUrl);
    print(response);

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
      padding: EdgeInsets.all(18),
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
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "1.06km",
            textAlign: TextAlign.left,
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
                      widget.availablePlaces[index].coordinate!),
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
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                Expanded(
                    child: Text(
                  "Kevin Goris",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.switch_left_rounded,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                Expanded(
                    child: Text(
                  "medium size",
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
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.confirmation_num)),
                      Text("CONFIRM")
                    ],
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
