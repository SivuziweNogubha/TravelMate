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
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['destinationLoaction']),
              subtitle: Text(
                'Departure: ${data['departureLoaction']} on ${data['departureDateTime']}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
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
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      _showDeleteDialog(context, document.id);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
  Future<void> deleteLift(String liftId) async {
    await FirebaseFirestore.instance.collection('lifts').doc(liftId).delete();
  }
  void _showDeleteDialog(BuildContext context, String liftId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Lift'),
          content: Text('Are you sure you want to delete this lift?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                await deleteLift(liftId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// class JoinedRidesView extends StatelessWidget {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: StreamBuilder<QuerySnapshot>(
//         stream: getUserLifts(FirebaseAuth.instance.currentUser!.uid),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }
//
//           final lifts = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: lifts.length,
//             itemBuilder: (context, index) {
//               final lift = lifts[index];
//
//               return ListTile(
//                 title: Text(lift['destinationLoaction']),
//                 subtitle: Text('Departure: ${lift['departureLoaction']} on ${lift['departureDateTime']}'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.cancel),
//                   onPressed: () async{
//                     String lift_id = lift.id;
//                     String userId = FirebaseAuth.instance.currentUser!.uid;
//                     await cancelLift(lift_id, userId);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

class JoinedRidesView extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: getUserLifts(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final lifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: lifts.length,
            itemBuilder: (context, index) {
              final lift = lifts[index];

              return ListTile(
                title: Text(lift['destinationLoaction']),
                subtitle: Text('Departure: ${lift['departureLoaction']} on ${lift['departureDateTime']}'),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _showCancelDialog(context, lift.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }


  void _showCancelDialog(BuildContext context, String liftId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Lift'),
          content: Text('Are you sure you want to cancel this lift?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                await cancelLift(liftId, userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Stream<QuerySnapshot> getUserLifts(String userId) {
    return FirebaseFirestore.instance
        .collection('lifts')
        .where('passengers', arrayContains: userId)
        .snapshots();
  }

  Future<void> cancelLift(String liftId, String userId) async {
    DocumentReference liftDoc = FirebaseFirestore.instance.collection('lifts').doc(liftId);

    await liftDoc.update({
      'passengers': FieldValue.arrayRemove([userId])
    });

    await liftDoc.update({
      'availableSeats': FieldValue.increment(1)
    });
  }





}