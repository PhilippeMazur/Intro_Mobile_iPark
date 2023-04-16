import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class AvailablePlacesBottomscroller extends StatefulWidget {
  final List<int> data;

  const AvailablePlacesBottomscroller({super.key, required this.data});

  @override
  State<AvailablePlacesBottomscroller> createState() =>
      _AvailablePlacesBottomscrollerState();
}

class _AvailablePlacesBottomscrollerState
    extends State<AvailablePlacesBottomscroller> {
  late List<int> data;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return Container(
      width: 260,
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Text("i:$index\n${data[index]}"),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {},
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.confirmation_num)),
                      Text("CONFIRM")
                    ],
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.transparent,
      child: ScrollSnapList(
          clipBehavior: Clip.none,
          margin: const EdgeInsets.only(bottom: 30),
          onItemFocus: _onItemFocus,
          itemSize: 260,
          itemBuilder: _buildListItem,
          itemCount: data.length,
          dynamicItemSize: true,
          dynamicSizeEquation: (distance) =>
              1 - min(distance.abs() / 500, 0.2)),
    );
  }
}