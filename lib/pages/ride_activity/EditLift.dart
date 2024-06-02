import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/lift.dart';
import '../../model/lifts_view_model.dart';
import '../../repository/lifts_repository.dart';

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
  late TextEditingController _depatureStreet;
  late TextEditingController _depatureTown;

  late TextEditingController _destinationController;
  late TextEditingController _destinationStreet;
  late TextEditingController _destinationTown;


  late DateTime _dateTime;
  int _availableSeats = 1;

  @override
  void initState() {
    super.initState();
    _departureLocationController =
        TextEditingController(text: widget.initialLiftData['departureLoacation']);
    _destinationController =
        TextEditingController(text: widget.initialLiftData['destinationLoaction']);
    _dateTime = widget.initialLiftData['departureDateTime'].toDate();
    _availableSeats = widget.initialLiftData['availableSeats'];
  }
  //I NEED TO HAVE THIS LOGIC ON LIFTSVIEWMODEL
  final _viewModel = LiftsViewModel(LiftsRepository());

  Future<void> _submitUpdate() async {
    // final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (_formKey.currentState!.validate()) {
      final updatedLiftData = Lift( // Assuming Lift is your data structure class
        departureLocation: _departureLocationController.text,
        destinationLocation: _destinationController.text,
        departureDateTime: _dateTime,
        availableSeats: _availableSeats,
        liftId: widget.liftId,
        offeredBy:FirebaseAuth.instance.currentUser!.uid ,
      );

      // Call updateLift method in ViewModel
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
        title: Text('Edit Ride Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Date and Time:'),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDateTime = await showDatePicker(
                        context: context,
                        initialDate: _dateTime ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDateTime != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              _dateTime ?? DateTime.now()),
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