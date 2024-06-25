import 'dart:ui';

import 'package:flutter/material.dart';


import '../../utils/important_constants.dart';
import 'joined_rides.dart';
import 'offered_rides.dart';

class MyRidesTab extends StatefulWidget {
  @override
  _MyRidesTabState createState() => _MyRidesTabState();
}

class _MyRidesTabState extends State<MyRidesTab> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Image.asset(
              'assets/pictures/dark_map.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Optional overlay to adjust brightness/contrast
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      Card(

        color: AppColors.backgroundColor,


        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 64.0),
        child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            // title: Text('My Rides'),
            bottom: TabBar(
              // dividerColor: Colors.green,
              labelStyle: TextStyle(color: Colors.white),
              indicatorColor: Colors.white,
              tabs: [
                Tab(text:  'Offered Rides'),
                Tab(text: 'Joined Rides'),
              ],
            ),
            centerTitle: true,
          ),
          body: Container(
            color: AppColors.backgroundColor,
            child: TabBarView(
              children: [
                OfferedRidesView(),
                JoinedRidesView(),
              ], // Set background color here

            ),
          ),
        ),
            ),
      )
    ]
    );
  }
}
