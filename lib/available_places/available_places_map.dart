import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../model/parking_spot_model.dart';

class AvailablePlacesMap extends StatefulWidget {
  final List<ParkingSpotModel> availablePlaces;
  const AvailablePlacesMap({super.key, required this.availablePlaces});
  @override
  State<AvailablePlacesMap> createState() => _AvailablePlacesMapState();
}

class _AvailablePlacesMapState extends State<AvailablePlacesMap> {
  late final MapController _mapController;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(51.260197, 4.402771),
        zoom: 14,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
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
