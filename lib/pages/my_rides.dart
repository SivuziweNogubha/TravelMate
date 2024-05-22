import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifts_app/pages/EditLift.dart';
class MyRidesTab extends StatefulWidget {
  @override
  _MyRidesTabState createState() => _MyRidesTabState();
}

class _MyRidesTabState extends State<MyRidesTab> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // title: Text('My Rides'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Offered Rides'),
              Tab(text: 'Joined Rides'),
            ],
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            OfferedRidesView(),
            JoinedRidesView(),
          ],
        ),
      ),
    );
  }
}

class OfferedRidesView extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('lifts')
          .where('offeredBy', isEqualTo: _auth.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['destinationLoaction']),
              subtitle: Text(
                'Departure: ${data['departureLoaction']} on ${data['departureDateTime']}',
              ),
              // trailing: IconButton(
              //   icon: Icon(Icons.cancel),
              //   onPressed: () {
              //     // Cancel or delete the offered ride
              //   },
              // ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditLiftScreen(
                        liftId: document.id,
                        initialLiftData: data,
                      ),
                    ),
                  );
                },
              ),

            );
          }).toList(),
        );
      },
    );
  }
}

class JoinedRidesView extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('bookings')
          .where('passengerId', isEqualTo: _auth.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data()! as Map<String, dynamic>;
            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.doc(data['liftId']).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshotLift) {
                if (snapshotLift.hasError) {
                  return Text('Error: ${snapshotLift.error}');
                }

                if (snapshotLift.connectionState == ConnectionState.done) {
                  Map<String, dynamic> liftData =
                  snapshotLift.data!.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(liftData['destination']),
                    subtitle: Text(
                      'Departure: ${liftData['departureLocation']} on ${liftData['dateTime'].toDate()}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        // Cancel the joined ride
                      },
                    ),
                  );
                }

                return CircularProgressIndicator();
              },
            );
          }).toList(),
        );
      },
    );
  }
}