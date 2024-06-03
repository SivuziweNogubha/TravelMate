//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
//
// class FindRideTab extends StatefulWidget {
//   @override
//   _FindRideTabState createState() => _FindRideTabState();
// }
//
// class _FindRideTabState extends State<FindRideTab> {
//   final _destinationController = TextEditingController();
//   DateTime? _dateTime;
//   List<DocumentSnapshot>? _searchResults;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         // This is retained in case you want to use current location for some other purpose
//       });
//     } catch (e) {
//       print('Error getting current location: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Card(
//           margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   autofocus: false,
//                   controller: _destinationController,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter a destination';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _destinationController.text = value!;
//                   },
//                   textInputAction: TextInputAction.done,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.location_pin),
//                     contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//                     hintText: "Where to?",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Text('Date:'),
//                     SizedBox(width: 16.0),
//                     ElevatedButton(
//                       onPressed: () async {
//                         final pickedDateTime = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.now(),
//                           lastDate: DateTime(2100),
//                         );
//
//                         if (pickedDateTime != null) {
//                           setState(() {
//                             _dateTime = pickedDateTime;
//                           });
//                         }
//                       },
//                       child: Text(
//                         _dateTime == null
//                             ? 'Select Date'
//                             : DateFormat('yyyy-MM-dd').format(_dateTime!),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     _searchRides();
//                   },
//                   child: Text('Search Rides'),
//                 ),
//                 SizedBox(height: 16.0),
//                 Expanded(
//                   child: _searchResults == null
//                       ? Center(child: Text('No results yet.'))
//                       : _searchResults!.isEmpty
//                       ? Center(child: Text('No available rides found.'))
//                       : ListView.builder(
//                     itemCount: _searchResults!.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final ride =
//                       _searchResults![index].data() as Map<String, dynamic>;
//                       final liftId = _searchResults![index].id;
//                       final departureDateTime =
//                       (ride['departureDateTime'] as Timestamp).toDate();
//                       return ListTile(
//                         title: Text(ride['destinationLoaction']),
//                         subtitle: Text(
//                           'Departure: ${ride['departureLoaction']} on ${DateFormat('yyyy-MM-dd').format(departureDateTime)}',
//                         ),
//                         trailing: Text(
//                           'Available Seats: ${ride['availableSeats'].toString()}',
//                         ),
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text('Confirm Booking'),
//                                 content: Text('Do you want to book this lift?'),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     child: Text('Cancel'),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                   TextButton(
//                                     child: Text('Book'),
//                                     onPressed: () async {
//                                       Navigator.of(context).pop();
//                                       String mylift = liftId;
//                                       String userId = FirebaseAuth.instance.currentUser!.uid;
//                                       await joinLift(mylift, userId);
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> joinLift(String liftId, String userId) async {
//     DocumentReference liftDoc = FirebaseFirestore.instance.collection('lifts').doc(liftId);
//
//     await liftDoc.update({
//       'passengers': FieldValue.arrayUnion([userId])
//     });
//
//     await liftDoc.update({'availableSeats': FieldValue.increment(-1)});
//
//     DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
//
//     await userDoc.update({
//       'confirmedLifts': FieldValue.arrayUnion([liftId])
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Lift booked successfully')),
//     );
//   }
//
//   void _searchRides() async {
//     String destination = _destinationController.text;
//     DateTime? selectedDate = _dateTime;
//
//     if (destination.isEmpty || selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a destination and select a date')),
//       );
//       return;
//     }
//
//     Query query = FirebaseFirestore.instance.collection('lifts')
//         .where('destinationLoaction', isEqualTo: destination)
//         .where('departureDateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate));
//
//     QuerySnapshot querySnapshot = await query.get();
//     setState(() {
//       _searchResults = querySnapshot.docs;
//     });
//   }
// }

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lifts_app/pages/widgets/loading_animation.dart';

import '../../repository/lifts_repository.dart';

class FindRideTab extends StatefulWidget {
  @override
  _FindRideTabState createState() => _FindRideTabState();
}

class _FindRideTabState extends State<FindRideTab> {
  final _destinationController = TextEditingController();
  DateTime? _dateTime;
  List<DocumentSnapshot>? _searchResults;
  bool _isLoading = false;
  late GoogleMapController _googleMapController;
  Position? _currentPosition;

  final _liftsRepository = LiftsRepository();

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
                GooglePlaceAutoCompleteTextField(
                  textEditingController: _destinationController,
                  googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
                  inputDecoration: InputDecoration(
                    prefixIcon: ImageIcon(
                      AssetImage('assets/current_location.png'),
                      size: 5,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Where to?",
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
                    _destinationController.text = prediction.description!;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Date:'),
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
                          setState(() {
                            _dateTime = pickedDateTime;
                          });
                        }
                      },
                      child: Text(
                        _dateTime == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(_dateTime!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _searchRides,
                  child: Text('Search Rides'),
                ),
                SizedBox(height: 16.0),
                _isLoading
                    ? Center(child: CustomLoadingAnimation(
                      animationPath: 'assets/animations/loading.json',
                      height: 150,
                      width: 150,
                    ))
                    : Expanded(
                  child: _searchResults == null
                      ? Center(child: CustomLoadingAnimation(
                        animationPath: 'assets/animations/no_data.json',
                        height: 200,
                        width: 200,
                        ))
                      : _searchResults!.isEmpty
                      ? Center(child: CustomLoadingAnimation(
                        animationPath: 'assets/animations/no_data.json',
                        height: 200,
                        width: 200,
                      ))
                      : ListView.builder(
                    itemCount: _searchResults!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ride =
                      _searchResults![index].data() as Map<String, dynamic>;
                      final liftId = _searchResults![index].id;
                      final departureDateTime =
                      (ride['departureDateTime'] as Timestamp).toDate();
                      return
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          // color: Colors.grey,
                          child: ListTile(
                          title: Text(ride['destinationLoaction']),
                          subtitle: Text(
                            'Departure: ${ride['departureLoaction']} on ${DateFormat('yyyy-MM-dd').format(departureDateTime)}',
                          ),
                          trailing: Text(
                            'Available Seats: ${ride['availableSeats'].toString()}',
                          ),
                          onTap: () {
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
                                        String userId =
                                            FirebaseAuth.instance.currentUser!.uid;
                                        await joinLift(mylift, userId);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  void _searchRides() async {
    String destination = _destinationController.text;
    DateTime? selectedDate = _dateTime;
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (destination.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a destination and select a date')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<DocumentSnapshot> results = await _liftsRepository.searchRides(destination, selectedDate, currentUserId);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  Future<void> joinLift(String liftId, String userId) async {
    await _liftsRepository.joinLift(liftId, userId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lift booked successfully')),
    );
  }

}
