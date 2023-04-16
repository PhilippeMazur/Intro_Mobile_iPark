import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AvailablePlacesTypeBar extends StatefulWidget {
  const AvailablePlacesTypeBar({super.key});

  @override
  State<AvailablePlacesTypeBar> createState() => _AvailablePlacesTypeBarState();
}

class _AvailablePlacesTypeBarState extends State<AvailablePlacesTypeBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(250.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 10.0,
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            Icons.location_on,
            color: Color.fromARGB(255, 0, 152, 217),
            size: 32.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          Expanded(
            child: TextField(
              controller: TextEditingController(),
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
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
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                contentPadding: EdgeInsets.fromLTRB(15, 8, 12, 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
