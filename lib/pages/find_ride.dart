import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class FindRideTab extends StatefulWidget {
  @override
  _FindRideTabState createState() => _FindRideTabState();
}

class _FindRideTabState extends State<FindRideTab> {
  final LatLng _center = const LatLng(45.521563, -122.677433);
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _loadRideMarkers();
  }

  void _loadRideMarkers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lifts')
        .where('availableSeats', isGreaterThan: 0)
        .get();

    Set<Marker> markers = {};
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      LatLng location = LatLng(data['latitude'], data['longitude']);
      markers.add(
        Marker(
          markerId: MarkerId(doc.id),
          position: location,
          infoWindow: InfoWindow(
            title: data['destination'],
            snippet: 'Available Seats: ${data['availableSeats']}',
          ),
        ),
      );
    });

    setState(() {
      _markers = markers;
    });
  }
  final _destinationController = TextEditingController();
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _destinationController,
            decoration: InputDecoration(
              labelText: 'Destination',
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
                    final ride = availableRides[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(ride['destination']),
                      subtitle: Text(
                        'Departure: ${ride['departureLocation']} on ${ride['dateTime'].toDate()}',
                      ),
                      trailing: Text('Available Seats: ${ride['availableSeats']}'),
                      onTap: () {
                        // Navigate to ride details or booking screen
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getAvailableRidesStream() {
    final destination = _destinationController.text.trim().toLowerCase();
    final dateTime = _dateTime;

    if (destination.isNotEmpty && dateTime != null) {
      return FirebaseFirestore.instance
          .collection('lifts')
          .where('destination', isEqualTo: destination)
          .where('dateTime', isGreaterThanOrEqualTo: dateTime)
          .where('availableSeats', isGreaterThan: 0)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('lifts')
          .where('availableSeats', isGreaterThan: 0)
          .snapshots();
    }
  }

  void _searchRides() {
    setState(() {});
  }
}