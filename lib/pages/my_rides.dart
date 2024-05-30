import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifts_app/pages/EditLift.dart';
import 'package:intl/intl.dart';

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

class OfferedRidesView extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('lifts')
          .where('offeredBy', isEqualTo: _auth.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            Timestamp departureTimestamp = data['departureDateTime'];
            DateTime departureDateTime = departureTimestamp.toDate();
            String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(departureDateTime);

            return ListTile(
              title: Text(data['destinationLoaction']),
              subtitle: Text('Departure: ${data['departureLoaction']} on $formattedDateTime'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditLiftScreen(
                            liftId: document.id,
                            initialLiftData: data,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      _showDeleteDialog(context, document.id);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
  Future<void> deleteLift(String liftId) async {
    await FirebaseFirestore.instance.collection('lifts').doc(liftId).delete();
  }

  void _showDeleteDialog(BuildContext context, String liftId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Lift'),
          content: Text('Are you sure you want to delete this lift?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                await deleteLift(liftId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
class JoinedRidesView extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: getUserLifts(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final lifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: lifts.length,
            itemBuilder: (context, index) {
              final lift = lifts[index];

              return ListTile(
                title: Text(lift['destinationLoaction']),
                subtitle: Text('Departure: ${lift['departureLoaction']} on ${lift['departureDateTime']}'),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _showCancelDialog(context, lift.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }


  void _showCancelDialog(BuildContext context, String liftId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Lift'),
          content: Text('Are you sure you want to cancel this lift?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                await cancelLift(liftId, userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
  Stream<QuerySnapshot> getUserLifts(String userId) {
    return FirebaseFirestore.instance
        .collection('lifts')
        .where('passengers', arrayContains: userId)
        .snapshots();
  }


  //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
  Future<void> cancelLift(String liftId, String userId) async {
    DocumentReference liftDoc = FirebaseFirestore.instance.collection('lifts').doc(liftId);

    await liftDoc.update({
      'passengers': FieldValue.arrayRemove([userId])
    });

    await liftDoc.update({
      'availableSeats': FieldValue.increment(1)
    });
  }





}