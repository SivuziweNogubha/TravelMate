import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'EditLift.dart';
import '../widgets/loading_animation.dart';
import 'package:intl/intl.dart';


class OfferedRidesView extends StatefulWidget {
  @override
  OfferedRidesViewState createState() => OfferedRidesViewState();
}

class OfferedRidesViewState extends State<OfferedRidesView> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('lifts')
          .where('offeredBy', isEqualTo: _auth.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          _isLoading = false;
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              Timestamp departureTimestamp = data['departureDateTime'];
              DateTime departureDateTime = departureTimestamp.toDate();
              String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(departureDateTime);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(data['destinationLoaction']),
                  subtitle: Text('Departure: ${data['departureLoaction']} on $formattedDateTime'),
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
                          _showDeleteDialog(context, document.id);
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
              animationPath: 'assets/animations/no_data.json',
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
}




  //ALSO NEED TO MOVE THIS LOGIC TO THE LIFTS VIEW MODEL
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
