import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class LiftDetailsPage extends StatefulWidget {
  final String liftId;

  LiftDetailsPage({required this.liftId});

  @override
  _LiftDetailsPageState createState() => _LiftDetailsPageState();
}

class _LiftDetailsPageState extends State<LiftDetailsPage> {
  late Future<DocumentSnapshot> _liftDetails;
  late Future<DocumentSnapshot> _userDetails;
  late String _offeredBy;

  @override
  void initState() {
    super.initState();
    _liftDetails = _fetchLiftDetails();
  }

  Future<DocumentSnapshot> _fetchLiftDetails() async {
    final liftDoc = await FirebaseFirestore.instance.collection('lifts').doc(widget.liftId).get();
    if (liftDoc.exists) {
      _offeredBy = liftDoc['offeredBy'];
      _userDetails = _fetchUserDetails(_offeredBy);
    } else {
      throw Exception('Lift not found');
    }
    return liftDoc;
  }

  Future<DocumentSnapshot> _fetchUserDetails(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found');
    }
    return userDoc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lift Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: _liftDetails,
        builder: (context, liftSnapshot) {
          if (liftSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (liftSnapshot.hasError) {
            return Center(child: Text('Error: ${liftSnapshot.error}'));
          }
          if (!liftSnapshot.hasData || !liftSnapshot.data!.exists) {
            return Center(child: Text('Lift not found'));
          }
          final liftData = liftSnapshot.data!.data() as Map<String, dynamic>;

          return FutureBuilder<DocumentSnapshot>(
            future: _userDetails,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Center(child: Text('Error: ${userSnapshot.error}'));
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(child: Text('User not found'));
              }
              final userData = userSnapshot.data!.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lift Details:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Destination: ${liftData['destinationLoaction']}'),
                    Text('Departure: ${liftData['departureLoaction']} on ${DateFormat('yyyy-MM-dd').format((liftData['departureDateTime'] as Timestamp).toDate())}'),
                    Text('Available Seats: ${liftData['availableSeats']}'),
                    SizedBox(height: 20),
                    Text('Offered By:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Name: ${userData['name']}'),
                    Text('Email: ${userData['email']}'),
                    // Additional user details can be displayed here
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
