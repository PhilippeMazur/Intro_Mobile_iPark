import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'custom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: CustomAppBar(
        title: "Profiel",
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text("profile picture"),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        "35",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 40),
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
                      Text(
                        "0",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 40),
                      ),
                      Text("keer gehuurd")
                    ],
                  )),
                ],
              ),
            ),
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
