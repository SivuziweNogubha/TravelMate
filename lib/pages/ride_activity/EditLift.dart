import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/lift.dart';
import '../../model/lifts_view_model.dart';
import '../../repository/lifts_repository.dart';
import '../../src/google_maps_service.dart';

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
    _availableSeats = widget.initialLiftData['availableSeats'];
  }

  final _viewModel = LiftsViewModel(LiftsRepository());
  GoogleMapsService service = GoogleMapsService();

  Future<void> _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      String destinationImageUrl =
      await service.getDestinationPhotoUrl(_destinationController.text);

      GeoPoint departureCoordinates =
      await service.getLocationCoordinates(_departureLocationController.text);
      GeoPoint destinationCoordinates =
      await service.getLocationCoordinates(_destinationController.text);

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
        price: double.parse(_priceController.text),
      );

      await _viewModel.updateLift(widget.liftId, updatedLiftData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ride updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Ride Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _departureLocationController,
                decoration: InputDecoration(
                  labelText: 'Departure Location',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a departure location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price (Rands)',
                ),
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
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Date and Time:'),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_dateTime),
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
                          });
                        }
                      }
                    },
                    child: Text(
                      _dateTime.toString(),
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
                onPressed: _submitUpdate,
                child: Text('Update Ride'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
