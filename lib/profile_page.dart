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
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  String formatTimeStamp(Timestamp timestamp) {
    DateTime datetime = timestamp.toDate();
    return DateFormat('dd-MM-y HH:mm').format(datetime);
  }

  Future<String?> getUserFromUid(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('accounts')
        .where('user_uid', isEqualTo: uid)
        .get();
    return snapshot.docs.first["username"] as String?;
  }

  Future<String?> getUserFromReference(String ref) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('accounts').get();
    return snapshot.docs
        .firstWhere((document) => document.reference.id == ref)["username"];
  }

  Future<dynamic> geoPointToAddress(GeoPoint coordinate) async {
    final apiUrl =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${coordinate.latitude}&lon=${coordinate.longitude}&zoom=18&addressdetails=1';

    try {
      final response = await fetchJson(apiUrl);
      return response;
    } catch (e) {
      logger.e('Error during API call: $e');
      return null;
    }
  }

  String formatAdress(dynamic nominatimResponse) {
    dynamic address = nominatimResponse["address"];
    if (address == null) return "error";
    String townOrCity = address["town"] ?? address["city"];
    return '${address["road"] ?? ""} ${address["house_number"] ?? ""}, ${address["postcode"] ?? ""} $townOrCity';
  }

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
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 7, 0, 7),
                                      child: Text(formatTimeStamp(spot.from))),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("tot:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 7, 0, 7),
                                      child: Text(formatTimeStamp(spot.until))),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("verhuurd door:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 7, 0, 7),
                                    child: FutureBuilder<String?>(
                                      future: getUserFromUid(spot.user_uid),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String?> snapshot) {
                                        if (snapshot.hasData) {
                                          return (Text(snapshot.data!));
                                        } else {
                                          return (const Text(
                                              "er ging iets mis"));
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("gehuurd door:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 7, 0, 7),
                                    child: spot.reserved_by == null
                                        ? const Text("nog niemand")
                                        : FutureBuilder<String?>(
                                            future: getUserFromReference(
                                                spot.reserved_by!),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String?>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return (Text(snapshot.data!));
                                              } else {
                                                return (const Text(
                                                    "er ging iets mis"));
                                              }
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const Text("adres:",
                                      textAlign: TextAlign.right),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
                                    child: FutureBuilder<dynamic>(
                                      future:
                                          geoPointToAddress(spot.coordinate),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return (Text(
                                              formatAdress(snapshot.data!)));
                                        } else {
                                          return (const Text(
                                              "er ging iets mis"));
                                        }
                                      },
                                    ),
                                  ),
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
