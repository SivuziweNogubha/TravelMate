//
// import 'dart:ui';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:lifts_app/src/google_maps_service.dart';
//
// import '../../model/lift.dart';
//
// class OfferRideTab extends StatefulWidget {
//   @override
//   _OfferRideTabState createState() => _OfferRideTabState();
// }
//
// class _OfferRideTabState extends State<OfferRideTab> {
//   final _formKey = GlobalKey<FormState>();
//   final _departureLocationController = TextEditingController();
//   final _destinationController = TextEditingController();
// final  _priceController = TextEditingController();
//   DateTime? _dateTime;
//   int _availableSeats = 1;
//   late GoogleMapController _googleMapController;
//   Position? _currentPosition;
//     GoogleMapsService service = GoogleMapsService();
//
//
//   static const _initialCameraPosition = CameraPosition(
//     target: LatLng(-26.232590, 28.240967),
//     zoom: 14.4746,
//   );
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
//         _currentPosition = position;
//       });
//     } catch (e) {
//       print('Error getting current location: $e');
//     }
//   }
//
//   Future<void> _offerRide() async {
//     if (_formKey.currentState!.validate()) {
//       final user = FirebaseAuth.instance.currentUser;
//       final liftRef = FirebaseFirestore.instance.collection('lifts').doc();
//
//
//       String? departurePlaceId = await service.searchPlace(_departureLocationController.text);
//       String? destinationPlaceId = await service.searchPlace(_destinationController.text);
//
//
//       String destinationImageUrl = await service.getLocationPhoto(destinationPlaceId!);
//
//
//       GeoPoint departureCoordinates = await service.getLocationCoordinates(departurePlaceId!);
//       GeoPoint destinationCoordinates = await service.getLocationCoordinates(destinationPlaceId!);
//
//       final liftdata = Lift(
//         liftId: liftRef.id,
//         offeredBy: user!.uid,
//         departureLocation: _departureLocationController.text,
//         departureLat: departureCoordinates.latitude,
//         departureLng: departureCoordinates.longitude,
//         destinationLocation: _destinationController.text,
//         destinationLat: destinationCoordinates.latitude,
//         destinationLng: destinationCoordinates.longitude,
//         departureDateTime: _dateTime ?? DateTime.now(),
//         availableSeats: _availableSeats,
//         destinationImage: destinationImageUrl,
//         price: double.tryParse(_priceController.text) ?? 0.0,
//       );
//
//       if (_departureLocationController.text.isNotEmpty &&
//           _destinationController.text.isNotEmpty &&
//           _dateTime != null) {
//         try {
//           await liftRef.set(liftdata.toJson());
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Ride offered successfully')),
//           );
//           _resetForm();
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to offer ride: $e')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please fill in all fields')),
//         );
//       }
//     }
//   }
//
//   void _resetForm() {
//     _departureLocationController.clear();
//     _destinationController.clear();
//     _priceController.clear();
//     setState(() {
//       _dateTime = null;
//       _availableSeats = 1;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _currentPosition != null
//             ? GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(
//               _currentPosition!.latitude,
//               _currentPosition!.longitude,
//             ),
//             zoom: 15,
//           ),
//           onMapCreated: (GoogleMapController controller) {
//             _googleMapController = controller;
//           },
//         )
//             : const Center(
//           child: CircularProgressIndicator(),
//         ),
//         Positioned.fill(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//             child: Container(
//               color: Colors.black.withOpacity(0.3),
//             ),
//           ),
//         ),
//         Card(
//           margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GooglePlaceAutoCompleteTextField(
//                       textEditingController: _departureLocationController,
//                       googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
//                       inputDecoration: InputDecoration(
//                         prefixIcon: ImageIcon(
//                           AssetImage('assets/current_location.png'),
//                           size: 24,
//                         ),
//                         contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//                         hintText: "Your location",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       countries: ["za"], // Specify your country code
//                       isLatLngRequired: true,
//                       getPlaceDetailWithLatLng: (prediction) {
//                         print("placeDetails: ${prediction.lng}");
//                       },
//                       itemClick: (prediction) {
//                         _departureLocationController.text = prediction.description!;
//                       },
//                     ),
//                     SizedBox(height: 16.0),
//                     GooglePlaceAutoCompleteTextField(
//                       textEditingController: _destinationController,
//                       googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
//                       inputDecoration: InputDecoration(
//                         prefixIcon: ImageIcon(
//                           AssetImage('assets/destination_location.png'),
//                           size: 24,
//                         ),
//                         contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//                         hintText: "Where to?",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       countries: ["za"],
//                       isLatLngRequired: true,
//                       getPlaceDetailWithLatLng: (prediction) {
//                         print("placeDetails: ${prediction.lng}");
//                       },
//                       itemClick: (prediction) {
//                         _destinationController.text = prediction.description!;
//                       },
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       children: [
//                         Image.asset(
//                           'assets/icons/date_time.png',
//                           width: 44,
//                           height: 44,
//                         ),
//                         SizedBox(width: 16.0),
//                         ElevatedButton(
//                           onPressed: () async {
//                             final pickedDateTime = await material.showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime(2100),
//                             );
//
//                             if (pickedDateTime != null) {
//                               final pickedTime = await material.showTimePicker(
//                                 context: context,
//                                 initialTime: TimeOfDay.now(),
//                               );
//
//                               if (pickedTime != null) {
//                                 setState(() {
//                                   _dateTime = DateTime(
//                                     pickedDateTime.year,
//                                     pickedDateTime.month,
//                                     pickedDateTime.day,
//                                     pickedTime.hour,
//                                     pickedTime.minute,
//                                   );
//                                 });
//                               }
//                             }
//                           },
//                           child: Text(
//                             _dateTime == null
//                                 ? 'Select Date and Time'
//                                 : _dateTime.toString(),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             side: BorderSide(color: Colors.blueGrey, width: 2), // Bluish outline
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       children: [
//                         Image.asset(
//                           'assets/icons/seats.png',
//                           width: 44,
//                           height: 44,
//                         ),
//                         SizedBox(width: 16.0),
//                         DropdownButton<int>(
//                           value: _availableSeats,
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() {
//                                 _availableSeats = value;
//                               });
//                             }
//                           },
//                           items: List.generate(
//                             3,
//                                 (index) => DropdownMenuItem(
//                               value: index + 1,
//                               child: Text('${index + 1}'),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     TextFormField(
//                       controller: _priceController,
//                       decoration: InputDecoration(
//                         labelText: '0.0',
//                         prefixIcon: ImageIcon(
//                           AssetImage('assets/icons/rands.png'), // Use the custom icon
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter a price';
//                         }
//                         if (double.tryParse(value) == null) {
//                           return 'Please enter a valid number';
//                         }
//                         return null;
//                       },
//                     ),
//                     // ElevatedButton(
//                     //   onPressed: _offerRide,
//                     //   child: Text('Offer Ride'),
//                     // ),
//                     SizedBox(height: 16.0),
//
//                     Positioned(
//                       bottom: 16.0,
//                       left: 0,
//                       right: 0,
//                       child: Center(
//                         child: ElevatedButton.icon(
//                           onPressed: _offerRide,
//                           icon: ImageIcon(AssetImage('assets/icons/car_passengers.png')),
//                           style: ElevatedButton.styleFrom(
//                             side: BorderSide(color: Colors.blueGrey, width: 2), // Bluish outline
//                           ),
//                           label: Text('Offer Ride'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'dart:ffi';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:lifts_app/src/google_maps_service.dart';
import '../../model/lift.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/important_constants.dart';
import '../widgets/loading_animation.dart';

class OfferRideTab extends StatefulWidget {
  @override
  _OfferRideTabState createState() => _OfferRideTabState();
}

class _OfferRideTabState extends State<OfferRideTab> {
  final _formKey = GlobalKey<FormState>();
  final _departureLocationController = TextEditingController();
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _dateTime;
  int _availableSeats = 1;
  late GoogleMapController _googleMapController;
  Position? _currentPosition;
  GoogleMapsService service = GoogleMapsService();
  TextEditingController _dateController = TextEditingController();
  // Bool destination = true as Bool;


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

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomLoadingAnimation(animationPath: 'assets/animations/loading.json');
        },
      );

      // Simulate a delay for loading animation
      await Future.delayed(Duration(seconds: 3));

      final user = FirebaseAuth.instance.currentUser;
      final liftRef = FirebaseFirestore.instance.collection('lifts').doc();

      String? departurePlaceId = await service.searchPlace(_departureLocationController.text);
      String? destinationPlaceId = await service.searchPlace(_destinationController.text);
      String destinationImageUrl = await service.getLocationPhoto(destinationPlaceId!);
      GeoPoint departureCoordinates = await service.getLocationCoordinates(departurePlaceId!);
      GeoPoint destinationCoordinates = await service.getLocationCoordinates(destinationPlaceId!);

      final liftdata = Lift(
        liftId: liftRef.id,
        offeredBy: user!.uid,
        departureLocation: _departureLocationController.text,
        departureLat: departureCoordinates.latitude,
        departureLng: departureCoordinates.longitude,
        destinationLocation: _destinationController.text,
        destinationLat: destinationCoordinates.latitude,
        destinationLng: destinationCoordinates.longitude,
        departureDateTime: _dateTime ?? DateTime.now(),
        availableSeats: _availableSeats,
        destinationImage: destinationImageUrl,
        status: 'pending',
        price: double.tryParse(_priceController.text) ?? 0.0,
      );

      if (_departureLocationController.text.isNotEmpty &&
          _destinationController.text.isNotEmpty &&
          _dateTime != null) {
        try {
          await liftRef.set(liftdata.toJson());
          Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          );
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
    _priceController.clear();
    _dateController.clear();
    setState(() {
      _dateTime = null;
      _availableSeats = 1;
    });
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
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 16.0),
                    _location(
                      icon: 'assets/destination_location.png',
                    ),
                    SizedBox(height: 16.0),
                    const Divider(color: Colors.white, thickness: 1),
                    SizedBox(height: 16.0),
                    _buildDateTimePicker(),
                    SizedBox(height: 16.0),
                    _buildSeatsAndPriceRow(),
                    SizedBox(height: 16.0),
                    _buildOfferRideButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutoCompleteTextField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
  }) {
    return GooglePlaceAutoCompleteTextField(
      textStyle: TextStyle(color: Colors.white),
      textEditingController: controller,
      googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
      inputDecoration: InputDecoration(
        prefixIcon: ImageIcon(
          AssetImage(icon),
          size: 24,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
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
        controller.text = prediction.description!;
      },
      itemBuilder: (context, index, Prediction prediction) => _buildPredictionItem(context, prediction, controller),
    );
  }

  Widget _buildPredictionItem(BuildContext context, Prediction prediction, TextEditingController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.text = prediction.description!;
            // Close the suggestions - you might need to implement this based on the package's capabilities
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/location_icon.svg", height: 24),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.structuredFormatting?.mainText ?? prediction.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          fontFamily: 'Aeonik',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        prediction.structuredFormatting?.secondaryText ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.highlightColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          fontFamily: 'Aeonik',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: AppColors.enabledBorderColor, thickness: 1),
      ],
    );
  }

  Widget _location({ required String icon}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/uber_line.svg',
          height: 70,
          // color: Colors.black,
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            children: [
              _buildAutoCompleteTextField(controller: _departureLocationController, hintText: "Your Location?", icon: icon),
              const SizedBox(height: 7),
              _buildAutoCompleteTextField(controller: _destinationController, hintText: "Where to?", icon: icon),

            ],
          ),
        )
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: _dateController,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            setState(() {
              _dateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              _dateController.text = _dateTime.toString();
            });
          }
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

  Widget _buildSeatsAndPriceRow() {
    return Row(
      children: [
        Image.asset(
          'assets/icons/seats.png',
          width: 44,
          height: 44,
          color: Colors.white,
        ),
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
              child: Container(color:Colors.black,child: Text('${index + 1}',style: TextStyle(color: Colors.white),)),

            ),
          ),
        ),
        SizedBox(width: 16.0), // Add spacing between seats and price
        Expanded(
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: ImageIcon(
                AssetImage('assets/icons/rands.png'),
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }


  Widget _buildOfferRideButton() {
    return Positioned(
      bottom: 16.0,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _offerRide,
          icon: ImageIcon(
            AssetImage('assets/icons/car_passengers.png'),
            color: Colors.white, // Set the icon color to white
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Set the button background color to black
            side: BorderSide(color: Colors.blueGrey, width: 2), // Bluish outline
          ),
          label: Text(
            'Offer Ride',
            style: TextStyle(color: Colors.white), // Set the text color to white
          ),
        ),
      ),
    );
  }
  
  

}
