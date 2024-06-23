import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:lifts_app/pages/widgets/loading_animation.dart';
import 'package:lifts_app/utils/important_constants.dart';

import '../../main.dart';
import '../../model/lift.dart';
import '../../model/lifts_view_model.dart';
import '../../repository/lifts_repository.dart';
import '../../src/google_maps_service.dart';
import 'package:flutter_svg/svg.dart';


// class EditLiftScreen extends StatefulWidget {
//   final String liftId;
//   final Map<String, dynamic> initialLiftData;
//
//   EditLiftScreen({required this.liftId, required this.initialLiftData});
//
//   @override
//   _EditLiftScreenState createState() => _EditLiftScreenState();
// }
//
// class _EditLiftScreenState extends State<EditLiftScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _departureLocationController;
//   late TextEditingController _destinationController;
//   late TextEditingController _priceController;
//
//   late DateTime _dateTime;
//   int _availableSeats = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     _departureLocationController = TextEditingController(
//         text: widget.initialLiftData['departureLocation']);
//     _destinationController = TextEditingController(
//         text: widget.initialLiftData['destinationLocation']);
//     _priceController = TextEditingController(
//         text: widget.initialLiftData['price'].toString());
//     _dateTime = widget.initialLiftData['departureDateTime'].toDate();
//     _availableSeats = widget.initialLiftData['availableSeats'];
//   }
//
//   final _viewModel = LiftsViewModel(LiftsRepository());
//   GoogleMapsService service = GoogleMapsService();
//
//   Future<void> _submitUpdate() async {
//     if (_formKey.currentState!.validate()) {
//       String? departurePlaceId = await service.searchPlace(_departureLocationController.text);
//       String? destinationPlaceId = await service.searchPlace(_destinationController.text);
//       String destinationImageUrl = await service.getLocationPhoto(destinationPlaceId!);
//       GeoPoint departureCoordinates = await service.getLocationCoordinates(departurePlaceId!);
//       GeoPoint destinationCoordinates = await service.getLocationCoordinates(destinationPlaceId!);
//
//       final updatedLiftData = Lift(
//         liftId: widget.liftId,
//         offeredBy: FirebaseAuth.instance.currentUser!.uid,
//         departureLocation: _departureLocationController.text,
//         departureLat: departureCoordinates.latitude,
//         departureLng: departureCoordinates.longitude,
//         destinationLocation: _destinationController.text,
//         destinationLat: destinationCoordinates.latitude,
//         destinationLng: destinationCoordinates.longitude,
//         departureDateTime: _dateTime,
//         availableSeats: _availableSeats,
//         destinationImage: destinationImageUrl,
//         price: double.parse(_priceController.text),
//       );
//
//       await _viewModel.updateLift(widget.liftId, updatedLiftData);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ride updated successfully')),
//       );
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Ride'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _departureLocationController,
//                   decoration: InputDecoration(
//                     labelText: 'Departure Location',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a departure location';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _destinationController,
//                   decoration: InputDecoration(
//                     labelText: 'Destination Location',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a destination location';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _priceController,
//                   decoration: InputDecoration(
//                     labelText: 'Price',
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a price';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Text('Available Seats:'),
//                     Expanded(
//                       child: Slider(
//                         value: _availableSeats.toDouble(),
//                         min: 1,
//                         max: 7,
//                         divisions: 6,
//                         label: _availableSeats.toString(),
//                         onChanged: (value) {
//                           setState(() {
//                             _availableSeats = value.toInt();
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _submitUpdate,
//                   child: Text('Update Ride'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class EditLiftScreen extends StatefulWidget {
  final String liftId;
  final Map<String, dynamic> initialLiftData;

  EditLiftScreen({required this.liftId, required this.initialLiftData});

  @override
  _EditLiftScreenState createState() => _EditLiftScreenState();
}

class _EditLiftScreenState extends State<EditLiftScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _departureLocationController;
  late TextEditingController _destinationController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;

  late DateTime _dateTime;
  int _availableSeats = 1;

  @override
  void initState() {
    super.initState();
    _departureLocationController = TextEditingController(
        text: widget.initialLiftData['departureLocation']);
    _destinationController = TextEditingController(
        text: widget.initialLiftData['destinationLocation']);
    _priceController = TextEditingController(
        text: widget.initialLiftData['price'].toString());
    _dateTime = widget.initialLiftData['departureDateTime'].toDate();
    _dateController = TextEditingController(
        text: _dateTime.toString());
    _availableSeats = widget.initialLiftData['availableSeats'];

  }

  final _viewModel = LiftsViewModel(LiftsRepository());
  GoogleMapsService service = GoogleMapsService();
  // TextEditingController _dateController = TextEditingController();


  Future<void> _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? departurePlaceId = await service.searchPlace(_departureLocationController.text);
        String? destinationPlaceId = await service.searchPlace(_destinationController.text);
        String destinationImageUrl = await service.getLocationPhoto(destinationPlaceId!);
        GeoPoint departureCoordinates = await service.getLocationCoordinates(departurePlaceId!);
        GeoPoint destinationCoordinates = await service.getLocationCoordinates(destinationPlaceId!);

        final updatedLiftData = Lift(
          liftId: widget.liftId,
          offeredBy: FirebaseAuth.instance.currentUser!.uid,
          departureLocation: _departureLocationController.text,
          departureLat: departureCoordinates.latitude,
          departureLng: departureCoordinates.longitude,
          destinationLocation: _destinationController.text,
          destinationLat: destinationCoordinates.latitude,
          destinationLng: destinationCoordinates.longitude,
          departureDateTime: _dateTime,
          availableSeats: _availableSeats,
          destinationImage: destinationImageUrl,
          status: 'pending',
          price: double.parse(_priceController.text),
        );

        await _viewModel.updateLift(widget.liftId, updatedLiftData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ride updated successfully')),
        );
        Navigator.pop(context); // Dismiss the dialog
        Navigator.pop(context); // Navigate back
      } catch (e) {
        Navigator.pop(context); // Dismiss the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update ride: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: ImageIcon(
            AssetImage('assets/back.png'), // Replace with your icon path
            size: 50,
            color: Colors.white,
          ),
          color: primary,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Edit Ride',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                fontFamily: 'Aeonik',
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              color: Colors.white,
              'assets/icons/edit.png',
              width: 44,
              height: 74,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [

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
    );
  }

  Widget _buildOfferRideButton() {
    return Positioned(
      bottom: 16.0,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _submitUpdate,
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

}
