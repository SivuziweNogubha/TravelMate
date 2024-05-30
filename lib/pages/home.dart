// import 'dart:js';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifts_app/home_page.dart';
import 'package:lifts_app/model/lifts_view_model.dart';
import 'package:lifts_app/pages/AutoSearch.dart';
import 'package:provider/provider.dart';
import 'package:lifts_app/pages/find_ride.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifts_app/pages/my_rides.dart';
import '../model/lift.dart';
import 'package:lifts_app/pages/login_screen.dart';
import 'package:lifts_app/Map.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  static  List<Widget> _widgetOptions = <Widget>[
    OfferRideTab(),
    // MapSample(),
    FindRideTab(),
    MyRidesTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelMate'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          // Padding(
          //
          //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
          //   child: InkWell(
          //     splashColor: Colors.transparent,
          //     focusColor: Colors.transparent,
          //     hoverColor: Colors.transparent,
          //     highlightColor: Colors.transparent,
          //     onTap: () async {
          //       await googleSignIn.signOut();
          //       await FirebaseAuth.instance.signOut();
          //       Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(builder: (context) => login_screen()),
          //       );
          //     },
          //     child: Icon(
          //       Icons.logout,
          //       color: Theme.of(context).primaryIconTheme.color,
          //       size: 30,
          //     ),
          //   ),
          // ),

          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => login_screen()),
                );
              },
              child: ImageIcon(
                AssetImage('assets/logout.png'), // Replace with your icon path
                size: 30,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
        ],
      ),



      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/car_passengers.png'),
                  size: 28,
                ),
                label: 'Offer Ride',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/passenger.png'),
                  size: 28,
                ),
                label: 'Find Ride',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/activity.png'),
                  size: 28,
                ),
                label: 'My Rides',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue[800],
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            iconSize: 28,
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            enableFeedback: true,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

//
// void main(){
//   runApp(
//     ChangeNotifierProvider(
//         create: (context)=> LiftsViewModel(),
//         child: MaterialApp(
//           title: 'TravelMate',
//           home: const HomePage(),
//         ),
//     )
//
//   );
// }



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




  Future<void> _offerRide() async {

    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      final liftRef = FirebaseFirestore.instance.collection('lifts').doc();
      final liftdata = Lift(liftId: liftRef.id,
          offeredBy:user!.uid ,
          departureLocation: _departureLocationController.text,
          destinationLocation: _destinationController.text,
          departureDateTime: _dateTime ?? DateTime.now(),
          availableSeats: _availableSeats,
      );

      try {
        await liftRef.set(liftdata.toJson());
        // await FirebaseFirestore.instance.collection('lifts').add(liftdata.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ride offered successfully')),
        );
        _resetForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to offer ride: $e')),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

                TextFormField(
                autofocus: false,
                controller: _departureLocationController,
                validator: (value) {
                  if (value!.isEmpty) {
                        return 'Please enter a departure location';
                      }
                      return null;
                },
                onSaved: (value) {
                  _departureLocationController.text = value!;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: ImageIcon(
                    AssetImage('assets/current_location.png'),
                    size: 24, // Adjust size as needed
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Your location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Text(''
              ),
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
                  prefixIcon: ImageIcon(
                    AssetImage('assets/destination_location.png'),
                    size: 24, // Adjust size as needed
                  ),
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
                      5,
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
          ]
    );
  }
}