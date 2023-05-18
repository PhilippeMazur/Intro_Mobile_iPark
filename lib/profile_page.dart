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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: const CustomAppBar(
        title: "Profiel",
      ),
      body: Padding(
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
                          logger.d(Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .user!
                              .id);
                          logger.d(snapshot.data!.docs);
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
                          logger.d(Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .user!
                              .id);
                          logger.d(snapshot.data!.docs);
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
            )
          ],
        ),
      ),
    );
  }
}
