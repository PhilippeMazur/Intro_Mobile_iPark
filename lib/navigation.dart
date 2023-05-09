import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ipark/available_places/available_places.dart';
import 'package:ipark/verhuren.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late PageController _pageController;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _listOfWidget,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: onButtonPressed,
        iconSize: 30,
        activeColor: const Color(0xFF01579B),
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(
            icon: Icons.car_rental_outlined,
            title: 'Verhuren',
          ),
          BarItem(
            icon: Icons.search_rounded,
            title: 'Huren',
          ),
        ],
      ),
    );
  }
}

List<Widget> _listOfWidget = <Widget>[
  Verhuren(),
  const AvailablePlaces(),
];
