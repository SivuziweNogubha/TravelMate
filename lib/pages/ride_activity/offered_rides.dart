// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:lifts_app/repository/lifts_repository.dart';
// import 'package:lifts_app/view_models/ride_view_model.dart';
// import 'EditLift.dart';
// import '../widgets/loading_animation.dart';
// import 'package:intl/intl.dart';
//
//
// class OfferedRidesView extends StatefulWidget {
//   @override
//   OfferedRidesViewState createState() => OfferedRidesViewState();
// }
//
// class OfferedRidesViewState extends State<OfferedRidesView> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   LiftsRepository liftsRepository = LiftsRepository();
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
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('lifts')
//           .where('offeredBy', isEqualTo: _auth.currentUser!.uid)
//           .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//           _isLoading = false;
//
//
//           DateTime now = DateTime.now();
//           List<DocumentSnapshot> validLifts = snapshot.data!.docs.where((DocumentSnapshot document) {
//             Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//             Timestamp departureTimestamp = data['departureDateTime'];
//             DateTime departureDateTime = departureTimestamp.toDate();
//             return departureDateTime.isAfter(now);
//           }).toList();
//
//           if (validLifts.isEmpty) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomLoadingAnimation(
//                   animationPath: 'assets/animations/no_data.json',
//                   width: 200,
//                   height: 200,
//                 ), // Show custom animation for no data
//                 SizedBox(height: 20),
//               ],
//             );
//           }
//
//           return ListView(
//             children: validLifts.map((DocumentSnapshot document) {
//               Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//               Timestamp departureTimestamp = data['departureDateTime'];
//               DateTime departureDateTime = departureTimestamp.toDate();
//               String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(departureDateTime);
//
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8.0),
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(
//                     color: Colors.indigo,
//                     width: 2.0, // Set the border width
//                   ),
//                   borderRadius: BorderRadius.circular(8.0), // Set the border radius if needed
//                 ),
//                 child: ListTile(
//                   leading: Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                       image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: data['destinationImage'] != null && data['destinationImage'].isNotEmpty
//                             ? NetworkImage(data['destinationImage'])
//                             : AssetImage('assets/logo.png') as ImageProvider,
//                       ),
//                     ),
//                   ),
//                   title: Text(data['destinationLocation']),
//                   subtitle: Text('Departure: ${data['departureLocation']} on $formattedDateTime fare: R${data['price']}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: ImageIcon(
//                           AssetImage('assets/icons/edit.png'),
//                           size: 20, // Adjust size as needed
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => EditLiftScreen(
//                                 liftId: document.id,
//                                 initialLiftData: data,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       IconButton(
//                         icon: ImageIcon(
//                           AssetImage('assets/icons/delete.png'),
//                           size: 30, // Adjust size as needed
//                         ),
//                         onPressed: () {
//                           print(document.id);
//                           _showDeleteDialog(context, document.id,liftsRepository);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         } else {
//           if (_isLoading) {
//             return CustomLoadingAnimation(
//               animationPath: 'assets/animations/loading.json',
//               width: 200,
//               height: 200,
//             );
//
//           } else {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomLoadingAnimation(
//                   animationPath: 'assets/animations/no_data.json',
//                   width: 200,
//                   height: 200,
//                 ), // Show custom animation for no data
//                 SizedBox(height: 20),
//               ],
//             );
//           }
//         }
//       },
//     );
//   }
// }
//
//
//
//   void _showDeleteDialog(BuildContext context, String liftId,LiftsViewModel repo) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Lift'),
//           content: Text('Are you sure you want to delete this lift?'),
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
//                 await repo.deleteLift(liftId);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifts_app/view_models/ride_view_model.dart';
import 'EditLift.dart';
import '../widgets/loading_animation.dart';
import 'package:intl/intl.dart';


class OfferedRidesView extends StatefulWidget {
  @override
  OfferedRidesViewState createState() => OfferedRidesViewState();
}

class OfferedRidesViewState extends State<OfferedRidesView> {
  final _auth = FirebaseAuth.instance;
  LiftsViewModel liftsViewModel = LiftsViewModel();
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
    return StreamBuilder<QuerySnapshot>(
      stream: liftsViewModel.getLiftsStreamByUserId(_auth.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          _isLoading = false;

          DateTime now = DateTime.now();
          List<DocumentSnapshot> validLifts = snapshot.data!.docs.where((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            Timestamp departureTimestamp = data['departureDateTime'];
            DateTime departureDateTime = departureTimestamp.toDate();
            return departureDateTime.isAfter(now);
          }).toList();

          if (validLifts.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLoadingAnimation(
                  animationPath: 'assets/animations/no_data.json',
                  width: 200,
                  height: 200,
                ), // Show custom animation for no data
                SizedBox(height: 20),
              ],
            );
          }

          return ListView(
            children: validLifts.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              Timestamp departureTimestamp = data['departureDateTime'];
              DateTime departureDateTime = departureTimestamp.toDate();
              String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(departureDateTime);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.indigo,
                    width: 2.0, // Set the border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Set the border radius if needed
                ),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: data['destinationImage'] != null && data['destinationImage'].isNotEmpty
                            ? NetworkImage(data['destinationImage'])
                            : AssetImage('assets/logo.png') as ImageProvider,
                      ),
                    ),
                  ),
                  title: Text(data['destinationLocation']),
                  subtitle: Text('Departure: ${data['departureLocation']} on $formattedDateTime fare: R${data['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: ImageIcon(
                          AssetImage('assets/icons/edit.png'),
                          size: 20, // Adjust size as needed
                        ),
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
                        icon: ImageIcon(
                          AssetImage('assets/icons/delete.png'),
                          size: 30, // Adjust size as needed
                        ),
                        onPressed: () {
                          _showDeleteDialog(context, document.id, liftsViewModel);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          if (_isLoading) {
            return CustomLoadingAnimation(
              animationPath: 'assets/animations/loading.json',
              width: 200,
              height: 200,
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLoadingAnimation(
                  animationPath: 'assets/animations/no_data.json',
                  width: 200,
                  height: 200,
                ), // Show custom animation for no data
                SizedBox(height: 20),
              ],
            );
          }
        }
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String liftId, LiftsViewModel viewModel) {
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
                await viewModel.deleteLift(liftId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
