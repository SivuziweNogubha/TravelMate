import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifts_app/pages/ride_activity/EditLift.dart';
import 'package:intl/intl.dart';
import 'package:lifts_app/pages/widgets/loading_animation.dart';

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
    _currentPosition != null
    ? GoogleMap(
    initialCameraPosition: CameraPosition(
      target: LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    ),
    zoom: 15,
    ),
    onMapCreated: (GoogleMapController controller) {
    _googleMapController = controller;
    },
    )
        : const Center(
    child: CircularProgressIndicator(),
    ),

    Positioned.fill(
    child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: Container(
    color: Colors.black.withOpacity(0.3),
    ),
    ),
    ),

      Card(
        margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
        child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // title: Text('My Rides'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Offered Rides'),
                Tab(text: 'Joined Rides'),
              ],
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              OfferedRidesView(),
              JoinedRidesView(),
            ],
          ),
        ),
            ),
      )
    ]
    );
  }
}
