import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifts_app/Map.dart';
class FindRideTab extends StatefulWidget {
  @override
  _FindRideTabState createState() => _FindRideTabState();
}

class _FindRideTabState extends State<FindRideTab> {
  final _destinationController = TextEditingController();
  DateTime? _dateTime;
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autofocus: false,
                      controller: _destinationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a destination';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _destinationController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_pin),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Where to?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('Date and Time:'),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDateTime != null) {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  _dateTime = DateTime(
                                    pickedDateTime.year,
                                    pickedDateTime.month,
                                    pickedDateTime.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: Text(
                            _dateTime == null
                                ? 'Select Date and Time'
                                : _dateTime.toString(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _searchRides();
                      },
                      child: Text('Search Rides'),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _getAvailableRidesStream(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          final availableRides = snapshot.data!.docs;
                          if (availableRides.isEmpty) {
                            return Text('No available rides found');
                          }

                          return ListView.builder(
                              itemCount: availableRides.length,
                              itemBuilder: (BuildContext context, int index) {
                                final ride = availableRides[index].data() as Map<
                                    String,
                                    dynamic>;
                                final liftId = availableRides[index].id;
                                return ListTile(
                                  title: Text(ride['destinationLoaction']),
                                  subtitle: Text(
                                    'Departure: ${ride['departureLoaction']} on ${ride['departureDateTime']}',
                                  ),
                                  trailing: Text('Available Seats: ${ride['availableSeats']
                                      .toString()}'),
                                  onTap: () {
                                    // THIS IS THE BOOKING CONFIRMATION DIALOG
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Booking'),
                                          content: Text('Do you want to book this lift?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Book'),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                String mylift = liftId;
                                                String userId = FirebaseAuth.instance.currentUser!.uid;
                                                await joinLift(mylift, userId);

                                                // await bookLift(
                                                //     ride['liftId'], ride['availableSeats']);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                );
                              }
                          );
                        },
                      ),
                    ),
                  ],

                ),

              ),
          )
      ]
    );
  }


  //This is where i allow a user to join a lift, while also being added to the passengers list in the Lifts Collection
  //also need to move this logic to the LIFTS VIEW MODE
  Future<void> joinLift(String liftId, String userId) async {
    DocumentReference liftDoc = FirebaseFirestore.instance.collection('lifts').doc(liftId);

    await liftDoc.update({
      'passengers': FieldValue.arrayUnion([userId])
    });

    await liftDoc.update({
      'availableSeats': FieldValue.increment(-1)
    });
  }

  //This is where i query the database in firebase to stream the available rides for the user
  Stream<QuerySnapshot> _getAvailableRidesStream() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null) {
      return FirebaseFirestore.instance
          .collection('lifts')
          .where('offeredBy', isNotEqualTo: currentUserId)
          .snapshots();
    } else {
      return FirebaseFirestore.instance.collection('lifts').snapshots();
    }
  }


  void _searchRides() {
    setState(() {});
  }
}