

import 'dart:ui';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_date_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lifts_app/pages/find_ride/ride_details.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lifts_app/pages/widgets/loading_animation.dart';

import '../../model/BookingModel.dart';
import '../../repository/lifts_repository.dart';
import '../../src/google_maps_service.dart';
import '../../utils/important_constants.dart';

class FindRideTab extends StatefulWidget {
  @override
  _FindRideTabState createState() => _FindRideTabState();
}

class _FindRideTabState extends State<FindRideTab> {
  final _destinationController = TextEditingController();
  DateTime? _dateTime;
  List<DocumentSnapshot>? _searchResults;
  bool _isLoading = false;
  TextEditingController _dateController = TextEditingController();

  final _liftsRepository = LiftsRepository();
  final GoogleMapsService _mapsService = GoogleMapsService();


  @override
  void initState() {
    super.initState();
    _mapsService.getCurrentLocation();

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
          margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
          color: AppColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GooglePlaceAutoCompleteTextField(
                  textStyle: TextStyle(color: Colors.white),
                  textEditingController: _destinationController,
                  googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
                  inputDecoration: InputDecoration(
                    prefixIcon: ImageIcon(
                      AssetImage('assets/current_location.png'),
                      size: 5,
                    ),
                    prefixIconColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Where to?",
                    hintStyle: TextStyle(color: Colors.white),
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
                const Divider(color: Colors.white, thickness: 1),
                SizedBox(height: 16.0),
                _buildDateTimePicker(),
                SizedBox(height: 16.0),


            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _searchRides,
                  icon: ImageIcon(
                    AssetImage('assets/icons/car_passengers.png'),
                    color: Colors.white, // Set the icon color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Set the button background color to black
                    side: BorderSide(color: Colors.blueGrey, width: 2), // Bluish outline
                  ),
                  label: Text(
                    'Find Ride',
                    style: TextStyle(color: Colors.white), // Set the text color to white
                  ),
                ),
              ),
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

                      : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Available Rides!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(


                                                itemCount: _searchResults!.length,
                                                itemBuilder: (BuildContext context, int index) {
                            final ride =
                            _searchResults![index].data() as Map<String, dynamic>;
                            final liftId = _searchResults![index].id;
                            final departureDateTime =
                            (ride['departureDateTime'] as Timestamp).toDate();
                            return
                              Card(
                                color: AppColors.backgroundColor,

                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.indigo,
                                    width: 2.0, // Set the border width
                                  ),
                                  borderRadius: BorderRadius.circular(8.0), // Set the border radius if needed
                                ),
                                // color: Colors.grey,
                                child: ListTile(

                                  textColor: Colors.white,
                                title: Text(ride['destinationLocation']),
                                  // subtitle: Text(ride['departureDateTime']as String),
                                  subtitle: Text(
                                    'Departure: ${DateFormat('yyyy-MM-dd').format(departureDateTime)} Available Seats: ${ride['availableSeats'].toString()} ',
                                  ),
                                  subtitleTextStyle: TextStyle(color: Colors.white),

                                  leading: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(ride['destinationImage']),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    await confirm_ride(context, ride);
                                  },

                                // },
                              ),
                            );
                                                },
                                              ),
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> confirm_ride(BuildContext context, Map<String, dynamic> ride) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(ride['offeredBy']).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmRidePage(
            departureLocation: LatLng(ride['departureLat'], ride['departureLng']),
            destinationLocation: LatLng(ride['destinationLat'], ride['destinationLng']),
            offeredBy: ride['offeredBy'],
            offeredByName: userData['name'],
            offeredByPhotoUrl: userData['photoURL'],
            destination: ride['destinationLocation'],
            departure: ride['departureLocation'],
            price: ride['price'] as double,
            liftId: ride['liftId'],
            image: ride['destinationImage'],
            seat: ride['availableSeats'],
          ),
        ),
      );
    } else {
      // Handle case where user data is not found
      print('User data not found');
    }
  }


  Widget _buildDateTimePicker() {
    return TextField(
      controller: _dateController,
      style: TextStyle(color: Colors.white),
      readOnly: true,
      onTap: () async {
        final pickedDateTime = await showDatePicker(
          context: context,
          initialDate: _dateTime ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (pickedDateTime != null) {
          setState(() {
            _dateTime = pickedDateTime;
            _dateController.text = DateFormat('yyyy-MM-dd').format(_dateTime!);
          });
        }
      },
      decoration: InputDecoration(
        labelText: 'Select Date and Time',
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(Icons.calendar_today),
        prefixIconColor: Colors.white,
        border: OutlineInputBorder(),
      ),
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

    List<DocumentSnapshot> results = await _liftsRepository.searchRides(
        destination, selectedDate, currentUserId);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

}
