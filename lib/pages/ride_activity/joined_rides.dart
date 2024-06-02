// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../widgets/loading_animation.dart';
//
// class JoinedRidesView extends StatefulWidget {
//   @override
//   _JoinedRidesViewState createState() => _JoinedRidesViewState();
// }
//
// class _JoinedRidesViewState extends State<JoinedRidesView> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     // Simulate loading for at least 3 seconds
//     Future.delayed(Duration(seconds: 3), () {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: _isLoading
//           ? CustomLoadingAnimation(
//         animationPath: 'assets/animations/loading.json',
//         width: 200,
//         height: 200,
//       ) // Use your custom loading animation widget here
//           : StreamBuilder<QuerySnapshot>(
//         stream: getUserLifts(FirebaseAuth.instance.currentUser!.uid),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Text('No data available.');
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
//                   onPressed: () {
//                     _showCancelDialog(context, lift.id);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//   void _showCancelDialog(BuildContext context, String liftId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Cancel Lift'),
//           content: Text('Are you sure you want to cancel this lift?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Yes'),
//               onPressed: () async {
//                 String userId = FirebaseAuth.instance.currentUser!.uid;
//                 await cancelLift(liftId, userId);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
//   Stream<QuerySnapshot> getUserLifts(String userId) {
//     return FirebaseFirestore.instance
//         .collection('lifts')
//         .where('passengers', arrayContains: userId)
//         .snapshots();
//   }
//
//
//   //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
//   Future<void> cancelLift(String liftId, String userId) async {
//     DocumentReference liftDoc = FirebaseFirestore.instance.collection('lifts').doc(liftId);
//
//     await liftDoc.update({
//       'passengers': FieldValue.arrayRemove([userId])
//     });
//
//     await liftDoc.update({
//       'availableSeats': FieldValue.increment(1)
//     });
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/loading_animation.dart'; // Import your custom loading animation widget

class JoinedRidesView extends StatefulWidget {
  @override
  _JoinedRidesViewState createState() => _JoinedRidesViewState();
}

class _JoinedRidesViewState extends State<JoinedRidesView> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading for at least 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: getUserLifts(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   if (_isLoading) {
          //     return CustomLoadingAnimation(
          //       animationPath: 'assets/animations/loading.json',
          //       height: 200,
          //       width: 200,
          //     ); // Show custom loading animation
          //   } else {
          //     return CustomLoadingAnimation(
          //       animationPath: 'assets/animations/no_data.json',
          //       height: 200,
          //       width: 200,
          //     );
          //   }
          // }
          if (_isLoading) {
            return CustomLoadingAnimation(
                    animationPath: 'assets/animations/loading.json',
                    height: 200,
                    width: 200,
                  ); // Sh
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return CustomLoadingAnimation(
                    animationPath: 'assets/animations/no_data.json',
                    height: 200,
                    width: 200,
                  );
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


  //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
  Stream<QuerySnapshot> getUserLifts(String userId) {
    return FirebaseFirestore.instance
        .collection('lifts')
        .where('passengers', arrayContains: userId)
        .snapshots();
  }


  //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
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
