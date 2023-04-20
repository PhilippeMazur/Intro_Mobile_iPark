///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipark/chooseLocation.dart';
import 'package:ipark/login.dart';

class Verhuren extends StatelessWidget {

  static String adres = "Adres";
  static GeoPoint geopoint = GeoPoint(0,0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      color: Color(0x1fffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ///***If you have exported images you must have to copy those images in assets/images directory.
                        Image(
                          image:
                              AssetImage("../assets/images/intromobilelogo.png"),
                          height: 60,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                          child: Align(
                            alignment: Alignment(0.0, 0.0),
                            child: IconButton(
                              icon: Icon(Icons.account_circle),
                              onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => loginScreen()),
                      );
                    },
                              color: Color(0xff0b55c3),
                              iconSize: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Color(0x1f000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                      border: Border.all(color: Color(0x4d000000), width: 1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "Plaats beschikbaar stellen",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff0b54c2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(35, 10, 35, 5),
                    child: TextField(
                      controller: TextEditingController(),
                      obscureText: false,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff7e7e7e),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide:
                              BorderSide(color: Color(0xff000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide:
                              BorderSide(color: Color(0xff000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide:
                              BorderSide(color: Color(0xff000000), width: 1),
                        ),
                        hintText: adres,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: Color(0xfff2f2f3),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                        suffixIcon: Icon(Icons.search,
                            color: Color(0xff212435), size: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    child:

                        ///***If you have exported images you must have to copy those images in assets/images directory.
                        Image(
                      image: AssetImage("../assets/images/voorbeeldfotomap.png"),
                      height: 100,
                      width: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChooseLocation()),
                      );
                    },
                    color: Color(0xff0956c8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                      side: BorderSide(color: Color(0xff808080), width: 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Of plaats een speld",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 40,
                    minWidth: 140,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Color(0x1f000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                      border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Van: ",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 10,
                            color: Color(0xff000000),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: TextField(
                              controller: TextEditingController(),
                              obscureText: false,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                  borderSide: BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                  borderSide: BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                  borderSide: BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                hintText: "01/02/2023 - 18u30",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xff8a8a8a),
                                ),
                                filled: true,
                                fillColor: Color(0xfff2f2f3),
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 8, 12, 8),
                                suffixIcon: Icon(Icons.calendar_today,
                                    color: Color(0xff212435), size: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Tot: ",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 10,
                            color: Color(0xff000000),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                  borderSide: BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                  borderSide: BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                  borderSide: BorderSide(
                                      color: Color(0xff000000), width: 1),
                                ),
                                hintText: "01/02/2023 - 19u30",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xff949494),
                                ),
                                filled: true,
                                fillColor: Color(0xfff2f2f3),
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 8, 12, 8),
                                suffixIcon: Icon(Icons.calendar_today,
                                    color: Color(0xff212435), size: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: MaterialButton(
                      onPressed: () {},
                      color: Color(0xff0956c8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                        side: BorderSide(color: Color(0xff808080), width: 1),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "START SESSIE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      textColor: Color(0xffffffff),
                      height: 40,
                      minWidth: 140,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 73, 0, 0),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.14,
                decoration: BoxDecoration(
                  color: Color(0xff0a54c4),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}