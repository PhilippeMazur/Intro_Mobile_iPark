import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool navigationPopArrow;
  const CustomAppBar({
    Key? key,
    required this.title,
    bool? navigationPopArrow,
  })  : navigationPopArrow = navigationPopArrow ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: navigationPopArrow == true
          ? IconButton(
              iconSize: 30,
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      toolbarHeight: 70, // Set this height
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: const Border(
          bottom:
              BorderSide(color: Color.fromARGB(255, 0, 152, 217), width: 4)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 18,
          color: Color(0xff000000),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(70);
}
