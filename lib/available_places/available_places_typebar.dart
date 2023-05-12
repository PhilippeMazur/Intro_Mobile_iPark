import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipark/date_time_picker.dart';
import 'package:latlong2/latlong.dart';

import '../main.dart';

class AvailablePlacesTypeBar extends StatefulWidget {
  final Function(LatLng) changeChosenAddress;
  final DateTime fromDate;
  final DateTime untilDate;
  final Function(DateTime) setFromDate;
  final Function(DateTime) setUntilDate;
  const AvailablePlacesTypeBar(
      {super.key,
      required this.changeChosenAddress,
      required this.setFromDate,
      required this.setUntilDate,
      required this.fromDate,
      required this.untilDate});

  @override
  State<AvailablePlacesTypeBar> createState() => _AvailablePlacesTypeBarState();
}

class _AvailablePlacesTypeBarState extends State<AvailablePlacesTypeBar> {
  final TextEditingController _inputAddressController = TextEditingController();

  List<dynamic> addresses = <dynamic>[];
  Timer? _debounce;

  String formatAddress(dynamic nominatimResponse) {
    try {
      dynamic address = nominatimResponse["address"];
      if (address == null) return "error";
      String townOrCity =
          address["town"] ?? address["city"] ?? address["village"];
      return '${address["road"] ?? ""} ${address["house_number"] ?? ""}, ${address["postcode"] ?? ""} $townOrCity';
    } catch (e) {
      logger.e(e);
      return "er ging iets mis";
    }
  }

  void fetchAdresses() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 2000), () async {
      try {
        String value = _inputAddressController.text;
        String url =
            'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
        logger.d(url);

        var response = await http.get(Uri.parse(url));
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() => addresses = decodedResponse);
      } catch (e) {
        logger.e(e);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _inputAddressController.addListener(fetchAdresses);
  }

  @override
  void dispose() {
    _inputAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 0, 152, 217),
                      size: 32.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inputAddressController,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(200.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter adress",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 8, 12, 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            //                   <--- left side
                            color: Color.fromARGB(255, 173, 173, 173),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: DateTimePicker(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(90.0),
                                topLeft: Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color.fromARGB(255, 129, 129, 129),
                          ),
                          hintText: "van",
                          filled: true,
                          fillColor: Color.fromARGB(255, 245, 245, 245),
                          isDense: false,
                          contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                        ),
                        setState: widget.setFromDate,
                      ),
                    ),
                  ),
                  Expanded(
                    child: DateTimePicker(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(90.0),
                              topRight: Radius.circular(90.0)),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color.fromARGB(255, 129, 129, 129),
                        ),
                        hintText: "tot",
                        filled: true,
                        fillColor: Color.fromARGB(255, 245, 245, 245),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                      ),
                      setState: widget.setUntilDate,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
          child: StatefulBuilder(builder: ((context, setState) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addresses.length > 5 ? 5 : addresses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(formatAddress(addresses[index])),
                    onTap: () {
                      widget.changeChosenAddress(LatLng(
                          double.parse(addresses[index]["lat"]),
                          double.parse(addresses[index]["lon"])));
                      setState(() {
                        addresses = [];
                      });
                    },
                  );
                });
          })),
        ),
      ],
    );
  }
}
