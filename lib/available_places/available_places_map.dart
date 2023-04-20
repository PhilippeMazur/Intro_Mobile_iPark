import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../model/parking_spot_model.dart';

class AvailablePlacesMap extends StatefulWidget {
  final List<ParkingSpotModel> availablePlaces;
  final MapController mapController;
  const AvailablePlacesMap(
      {super.key, required this.availablePlaces, required this.mapController});
  @override
  State<AvailablePlacesMap> createState() => _AvailablePlacesMapState();
}

class _AvailablePlacesMapState extends State<AvailablePlacesMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        center: LatLng(51.260197, 4.402771),
        zoom: 14,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
      ),
      children: [
        TileLayer(
          tileProvider: NetworkTileProvider(),
          urlTemplate: 'http://mt{s}.google.com/vt/x={x}&y={y}&z={z}',
          subdomains: const ['0', '1', '2', '3'],
          retinaMode: true,
          maxZoom: 22,
        ),
        MarkerLayer(
          markers: [
            for (var spot in widget.availablePlaces)
              if (spot.coordinate?.latitude != null &&
                  spot.coordinate?.longitude != null)
                Marker(
                    point: LatLng(
                        spot.coordinate!.latitude, spot.coordinate!.longitude),
                    height: 50,
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    builder: (context) =>
                        Image.asset("assets/images/mapMarker.png")),
          ],
        ),
      ],
    );
  }
}
