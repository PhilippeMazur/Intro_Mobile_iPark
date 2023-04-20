import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AvailablePlacesMap extends StatefulWidget {
  const AvailablePlacesMap({super.key});

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
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
      ],
    );
  }
}
