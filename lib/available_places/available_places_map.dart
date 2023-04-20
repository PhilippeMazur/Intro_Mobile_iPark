import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../model/parking_spot_model.dart';

class AvailablePlacesMap extends StatefulWidget {
  final List<ParkingSpotModel> availablePlaces;
  final MapController mapController;
  final Function(int) snapToFunction;
  const AvailablePlacesMap(
      {super.key,
      required this.availablePlaces,
      required this.mapController,
      required this.snapToFunction});
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
            for (int i = 0; i < widget.availablePlaces.length; i++)
              if (widget.availablePlaces[i].coordinate?.latitude != null &&
                  widget.availablePlaces[i].coordinate?.longitude != null)
                Marker(
                  point: LatLng(widget.availablePlaces[i].coordinate!.latitude,
                      widget.availablePlaces[i].coordinate!.longitude),
                  height: 50,
                  anchorPos: AnchorPos.align(AnchorAlign.top),
                  builder: (context) => GestureDetector(
                      onTap: () => widget.snapToFunction(i),
                      child: Image.asset("assets/images/mapMarker.png")),
                ),
          ],
        ),
      ],
    );
  }
}
