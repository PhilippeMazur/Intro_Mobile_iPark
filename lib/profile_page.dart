import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ipark/provider/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

import 'custom_app_bar.dart';
import 'main.dart';
import 'model/parking_spot_model.dart';

class ProfilePage extends StatelessWidget {
  static List<String> sampleData = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5'
  ];

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: const CustomAppBar(
        title: "Profiel",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Image.asset(width: 130, "assets/images/profile_pic.png"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Consumer<AuthenticationProvider>(
                    builder: (context, login, child) {
                  return Text(
                    login.user?.username ?? "er ging iets mis",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 17,
                      color: Colors.blue,
                    ),
                  );
                }),
              ),
              IntrinsicHeight(
                  child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("parking_spots")
                            .where("user_uid",
                                isEqualTo: Provider.of<AuthenticationProvider>(
                                        context,
                                        listen: false)
                                    .user!
                                    .user_uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // React to the data received from the stream
                            return Text(
                              snapshot.data!.docs.length.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 40),
                            );
                          } else {
                            return Text('Waiting for data...');
                          }
                        },
                      ),
                      Text("keer verhuurd")
                    ],
                  )),
                  const VerticalDivider(
                    width: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("parking_spots")
                            .where("reserved_by",
                                isEqualTo: Provider.of<AuthenticationProvider>(
                                        context,
                                        listen: false)
                                    .user!
                                    .id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // React to the data received from the stream
                            return Text(
                              snapshot.data!.docs.length.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 40),
                            );
                          } else {
                            return Text('Waiting for data...');
                          }
                        },
                      ),
                      Text("keer gehuurd")
                    ],
                  )),
                ],
              )),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "geschidenis",
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: StreamGroup.merge([
                  FirebaseFirestore.instance
                      .collection("parking_spots")
                      .where("user_uid",
                          isEqualTo: Provider.of<AuthenticationProvider>(
                                  context,
                                  listen: false)
                              .user!
                              .user_uid)
                      .snapshots(),
                  FirebaseFirestore.instance
                      .collection("parking_spots")
                      .where("reserved_by",
                          isEqualTo: Provider.of<AuthenticationProvider>(
                                  context,
                                  listen: false)
                              .user!
                              .id)
                      .snapshots()
                ]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ParkingSpotModel> spots = [];
                    for (var map in snapshot.data!.docs) {
                      try {
                        var spot = ParkingSpotModel.fromMap(map.data());
                        spot.id = map.id;
                        spots.add(spot);
                      } catch (e) {
                        logger.d('Skipping object');
                      }
                    }
                    logger.d(spots.length);

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: spots.length,
                      itemBuilder: (context, index) {
                        final ParkingSpotModel spot = spots[index];
                        logger.d(spot.id);
                        return Container(
                          color: Colors.blue,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  const Text("van:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
                                      child: Text("test")),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("tot:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
                                      child: Text("test")),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("verhuurd door:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
                                      child: Text("test")),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("gehuurd door:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
                                      child: Text("test")),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("adres:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
                                      child: Text("test")),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
