import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifts_app/pages/ride_activity/EditLift.dart';
import 'package:intl/intl.dart';
import 'package:lifts_app/pages/widgets/loading_animation.dart';

import '../../utils/important_constants.dart';
import 'joined_rides.dart';
import 'offered_rides.dart';

class MyRidesTab extends StatefulWidget {
  @override
  _MyRidesTabState createState() => _MyRidesTabState();
}

class _MyRidesTabState extends State<MyRidesTab> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late GoogleMapController _googleMapController;
  Position? _currentPosition;

  static const _initialCameraPosition = CameraPosition(
    target:  LatLng(-26.232590, 28.240967),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
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
