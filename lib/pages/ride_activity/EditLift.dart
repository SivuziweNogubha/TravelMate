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

import '../widgets/Seats_and_price_widgets.dart';
import '../widgets/location_widget.dart';
import '../widgets/offering_ride_button.dart';

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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomLoadingAnimation(animationPath: 'assets/animations/loading.json');
        },
      );

      await Future.delayed(Duration(seconds: 5));

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
        Navigator.of(context, rootNavigator: true).pop();
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

                // _location(
                //   icon: 'assets/destination_location.png',
                // ),
                LocationWidget(
                  departureController: _departureLocationController,
                  destinationController: _destinationController,
                  icon: 'assets/destination_location.png',),
                SizedBox(height: 16.0),
                const Divider(color: Colors.white, thickness: 1),
                SizedBox(height: 16.0),
                _buildDateTimePicker(),
                SizedBox(height: 16.0),
                SeatsAndPriceRowWidget(
                  priceController: _priceController,
                  availableSeats: _availableSeats,) ,
                SizedBox(height: 16.0),
                OfferRideButtonWidget(onPressed: () { _submitUpdate(); },),
              ],
            ),
          ),
        ),
      ),
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



}
