
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifts_app/view_models/ride_view_model.dart';
import 'package:provider/provider.dart';

// import '../../model/lifts_view_model.dart';
// import '../view_models/lifts_view_model.dart';
import '../../utils/important_constants.dart';
import '../widgets/loading_animation.dart';

class JoinedRidesView extends StatefulWidget {
  @override
  _JoinedRidesViewState createState() => _JoinedRidesViewState();
}

class _JoinedRidesViewState extends State<JoinedRidesView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
    final liftsViewModel = Provider.of<LiftsViewModel>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: liftsViewModel.getJoinedLifts(FirebaseAuth.instance.currentUser!.uid),
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
                color: AppColors.backgroundColor,

                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.green,
                    width: 2.0, // Set the border width
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Set the border radius if needed
                ),
                child: ListTile(
                  textColor: Colors.white,

                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(data['destinationImage']),
                      ),
                    ),
                  ),
                  title: Text(data['destinationLocation']),
                  subtitle: Text('Departure: ${data['departureLocation']} on $formattedDateTime'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: ImageIcon(
                          color: Colors.white,
                          AssetImage('assets/icons/delete.png'),
                          size: 30, // Adjust size as needed
                        ),
                        onPressed: () {
                          _showCancelDialog(context, document.id, liftsViewModel);
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

  void _showCancelDialog(BuildContext context, String liftId, LiftsViewModel liftsViewModel) {
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
                await liftsViewModel.cancelLift(liftId, userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
