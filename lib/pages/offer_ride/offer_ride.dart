
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart'; // Ensure you have added this package in pubspec.yaml

import '../../model/lift.dart';

class OfferRideTab extends StatefulWidget {
  @override
  _OfferRideTabState createState() => _OfferRideTabState();
}

class _OfferRideTabState extends State<OfferRideTab> {
  final _formKey = GlobalKey<FormState>();
  final _departureLocationController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _dateTime;
  int _availableSeats = 1;
  late GoogleMapController _googleMapController;
  Position? _currentPosition;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-26.232590, 28.240967),
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

  Future<void> _offerRide() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      final liftRef = FirebaseFirestore.instance.collection('lifts').doc();
      final liftdata = Lift(
        liftId: liftRef.id,
        offeredBy: user!.uid,
        departureLocation: _departureLocationController.text,
        destinationLocation: _destinationController.text,
        departureDateTime: _dateTime ?? DateTime.now(),
        availableSeats: _availableSeats,
      );

      if (_departureLocationController.text.isNotEmpty &&
          _destinationController.text.isNotEmpty &&
          _dateTime != null) {
        try {
          await liftRef.set(liftdata.toJson());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ride offered successfully')),
          );
          _resetForm();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to offer ride: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
      }

    }
  }

  void _resetForm() {
    _departureLocationController.clear();
    _destinationController.clear();
    setState(() {
      _dateTime = null;
      _availableSeats = 1;
    });
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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GooglePlaceAutoCompleteTextField(
                      textEditingController: _departureLocationController,
                      googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
                      inputDecoration: InputDecoration(
                        prefixIcon: ImageIcon(
                          AssetImage('assets/current_location.png'),
                          size: 24,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Your location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      countries: ["za"], // Specify your country code
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {
                        print("placeDetails: ${prediction.lng}");
                      },
                      itemClick: (prediction) {
                        _departureLocationController.text = prediction.description!;
                      },
                    ),
                    SizedBox(height: 16.0),
                    GooglePlaceAutoCompleteTextField(
                      textEditingController: _destinationController,
                      googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
                      inputDecoration: InputDecoration(
                        prefixIcon: ImageIcon(
                          AssetImage('assets/destination_location.png'),
                          size: 24,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Where to?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      countries: ["za"],
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {
                        print("placeDetails: ${prediction.lng}");
                      },
                      itemClick: (prediction) {
                        _destinationController.text = prediction.description!;
                      },
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
                    Row(
                      children: [
                        Text('Available Seats:'),
                        SizedBox(width: 16.0),
                        DropdownButton<int>(
                          value: _availableSeats,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _availableSeats = value;
                              });
                            }
                          },
                          items: List.generate(
                            3,
                                (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _offerRide,
                      child: Text('Offer Ride'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
