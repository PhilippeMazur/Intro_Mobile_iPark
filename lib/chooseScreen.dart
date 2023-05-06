///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';
import 'package:ipark/available_places/available_places.dart';
import 'package:ipark/login.dart';
import 'package:ipark/provider/authentication_provider.dart';
import 'package:ipark/verhuren.dart';
import 'package:provider/provider.dart';

class choosePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("../assets/images/logoipark.png"),
              height: 250,
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
            width: MediaQuery.of(context).size.width * 0.8,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xB5B5B5),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(29.0),
            ),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Verhuren()),
                );
              },
              color: Color(0xffc9c9c9),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              padding: EdgeInsets.all(14),
              child: Text(
                "Verhuren",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
              textColor: Color.fromARGB(255, 8, 83, 195),
              height: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              padding: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0x1f000000),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(29.0),
                border: Border.all(color: Color(0x4d9e9e9e), width: 1),
              ),
              child: Align(
                alignment: Alignment(0.0, 1.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AvailablePlaces()),
                    );
                  },
                  color: Color.fromARGB(255, 8, 83, 195),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.all(14),
                  textColor: Color(0xffffffff),
                  height: MediaQuery.of(context).size.height,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Parkeren",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
