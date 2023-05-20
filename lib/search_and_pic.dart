// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class SearchAndPick extends StatefulWidget {
  final LatLng center;
  final void Function(PickedData pickedData) onPicked;
  final Future<LatLng> Function() onGetCurrentLocationPressed;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;
  final IconData currentLocationIcon;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color locationPinIconColor;
  final String buttonText;
  final String hintText;

  static Future<LatLng> nopFunction() {
    throw Exception("");
  }

  const SearchAndPick({
    Key? key,
    required this.center,
    required this.onPicked,
    this.zoomOutIcon = Icons.zoom_out_map,
    this.zoomInIcon = Icons.zoom_in_map,
    this.currentLocationIcon = Icons.my_location,
    this.onGetCurrentLocationPressed = nopFunction,
    this.buttonColor = Colors.blue,
    this.locationPinIconColor = Colors.blue,
    this.buttonTextColor = Colors.white,
    this.buttonText = 'Set Current Location',
    this.hintText = 'Search Location',
  }) : super(key: key);

  @override
  State<SearchAndPick> createState() => _SearchAndPickState();
}

class _SearchAndPickState extends State<SearchAndPick> {
  MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<OSMdata> _options = <OSMdata>[];
  Timer? _debounce;
  var client = http.Client();

  void setNameCurrentPos() async {
    double latitude = _mapController.center.latitude;
    double longitude = _mapController.center.longitude;
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

    var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }

  void setNameCurrentPosAtInit() async {
    double latitude = widget.center.latitude;
    double longitude = widget.center.longitude;
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

    var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }

  @override
  void initState() {
    _mapController = MapController();

    setNameCurrentPosAtInit();

    _mapController.mapEventStream.listen((event) async {
      if (event is MapEventMoveEnd) {
        var client = http.Client();
        String url =
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=${event.center.latitude}&lon=${event.center.longitude}&zoom=18&addressdetails=1';

        var response = await client.post(Uri.parse(url));
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
            as Map<dynamic, dynamic>;

        _searchController.text = decodedResponse['display_name'];
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
              child: FlutterMap(
            options: MapOptions(
              center: LatLng(51.229723, 4.41583),
              zoom: 14,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
            mapController: _mapController,
            children: [
              TileLayer(
                tileProvider: NetworkTileProvider(),
                urlTemplate: 'http://mt{s}.google.com/vt/x={x}&y={y}&z={z}',
                subdomains: const ['0', '1', '2', '3'],
                retinaMode: true,
                maxZoom: 22,
              ),
            ],
          )),
          Positioned.fill(
              child: IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Icon(
                  Icons.location_pin,
                  size: 80,
                  color: widget.locationPinIconColor,
                ),
              ),
            ),
          )),
          Positioned(
              bottom: 200,
              right: 5,
              child: FloatingActionButton(
                heroTag: 'btn1',
                backgroundColor: widget.buttonColor,
                onPressed: () {
                  _mapController.move(
                      _mapController.center, _mapController.zoom + 1);
                },
                child: Icon(
                  widget.zoomInIcon,
                  color: widget.buttonTextColor,
                ),
              )),
          Positioned(
              bottom: 140,
              right: 5,
              child: FloatingActionButton(
                heroTag: 'btn2',
                backgroundColor: widget.buttonColor,
                onPressed: () {
                  _mapController.move(
                      _mapController.center, _mapController.zoom - 1);
                },
                child: Icon(
                  widget.zoomOutIcon,
                  color: widget.buttonTextColor,
                ),
              )),
          Positioned(
              bottom: 80,
              right: 5,
              child: FloatingActionButton(
                heroTag: 'btn3',
                backgroundColor: widget.buttonColor,
                onPressed: () async {
                  try {
                    LatLng position =
                        await widget.onGetCurrentLocationPressed.call();
                    _mapController.move(
                        LatLng(position.latitude, position.longitude),
                        _mapController.zoom);
                  } catch (e) {
                    _mapController.move(
                        LatLng(widget.center.latitude, widget.center.longitude),
                        _mapController.zoom);
                  } finally {
                    setNameCurrentPos();
                  }
                },
                child: Icon(
                  widget.currentLocationIcon,
                  color: widget.buttonTextColor,
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                          style: BorderStyle.solid),
                    ),
                    child: TextFormField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: (String value) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();

                          _debounce = Timer(const Duration(milliseconds: 2000),
                              () async {
                            if (kDebugMode) {
                              print(value);
                            }
                            var client = http.Client();
                            try {
                              String url =
                                  'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
                              if (kDebugMode) {
                                print(url);
                              }
                              var response = await client.post(Uri.parse(url));
                              var decodedResponse =
                                  jsonDecode(utf8.decode(response.bodyBytes))
                                      as List<dynamic>;
                              if (kDebugMode) {
                                print(decodedResponse);
                              }
                              _options = decodedResponse
                                  .map((e) => OSMdata(
                                      displayname: e['display_name'],
                                      lat: double.parse(e['lat']),
                                      lon: double.parse(e['lon'])))
                                  .toList();
                              setState(() {});
                            } finally {
                              client.close();
                            }

                            setState(() {});
                          });
                        }),
                  ),
                  StatefulBuilder(builder: ((context, setState) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _options.length > 5 ? 5 : _options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_options[index].displayname),
                            subtitle: Text(
                                '${_options[index].lat},${_options[index].lon}'),
                            onTap: () {
                              _mapController.move(
                                  LatLng(
                                      _options[index].lat, _options[index].lon),
                                  15.0);

                              _focusNode.unfocus();
                              _options.clear();
                              setState(() {});
                            },
                          );
                        });
                  })),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  widget.buttonText,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                onPressed: () async {
                  pickData().then((value) {
                    widget.onPicked(value);
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<PickedData> pickData() async {
    LatLng center =
        LatLng(_mapController.center.latitude, _mapController.center.longitude);
    var client = http.Client();
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${_mapController.center.latitude}&lon=${_mapController.center.longitude}&zoom=18&addressdetails=1';

    var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
    String displayName = decodedResponse['display_name'];
    return PickedData(center, displayName);
  }
}

class OSMdata {
  final String displayname;
  final double lat;
  final double lon;
  OSMdata({required this.displayname, required this.lat, required this.lon});
  @override
  String toString() {
    return '$displayname, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OSMdata && other.displayname == displayname;
  }

  @override
  int get hashCode => Object.hash(displayname, lat, lon);
}

class PickedData {
  final LatLng latLong;
  final String address;

  PickedData(this.latLong, this.address);
}
