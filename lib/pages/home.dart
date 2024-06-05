import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifts_app/pages/profile.dart';
import 'package:lifts_app/pages/ride_activity/my_rides.dart';
import 'package:lifts_app/pages/find_ride/find_ride.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifts_app/pages/onboarding/login_screen.dart';
import '../dummy.dart';
import '../model/user_model.dart';
import 'offer_ride/offer_ride.dart';
import 'package:flutter_svg/svg.dart';


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, this.userModel}) : super(key: key);

  final String title;
  final UserModel? userModel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    final String uid = currentUser?.uid ?? '';
    final List<Widget> _widgetOptions = [
      OfferRideTab(),
      FindRideTab(),
      // MyRidesTab(),
      ProfilePage(uid: uid,),
      ProfileScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelMate'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
          elevation: 0,
          // actions: [
          //   GestureDetector(
          //       onTap: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (_) => const ChatsScreen())
          //         );
          //       },
          //       child: Container(
          //         height: 30,
          //         width: 30,
          //         margin: const EdgeInsets.only(right: 15),
          //         child: SvgPicture.asset(
          //           'assets/icons/chat_icon.svg',
          //         ),
          //       )
          //   )
          // ],
          // leading: GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const ProfileScreen())
          //     );
          //   },
          //   child: Container(
          //     width: 10,
          //     height: 10,
          //     margin: const EdgeInsets.only(left: 13, top: 8, bottom: 8),
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       // image: DecorationImage(
          //       //   image: NetworkImage(userPhotoUrl ?? AppValues.defaultUserImg),
          //       //   fit: BoxFit.cover,
          //       // ),
          //     ),
          //   ),
          // )

      ),



      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/car_passengers.png'),
                  size: 28,
                ),
                label: 'Offer Ride',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/passenger.png'),
                  size: 28,
                ),
                label: 'Find Ride',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/activity.png'),
                  size: 28,
                ),
                label: 'My Rides',
              ),
              // BottomNavigationBarItem(
              //   icon: ImageIcon(
              //     AssetImage('assets/profile.png'),
              //     size: 28,
              //   ),
              //   label: 'Profile',
              // ),
              BottomNavigationBarItem(
                icon: widget.userModel?.photoURL != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.userModel!.photoURL!),
                  radius: 14,
                )
                    : ImageIcon(
                  AssetImage('assets/profile.png'),
                  size: 28,
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue[800],
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            iconSize: 28,
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            enableFeedback: true,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

//
// void main(){
//   runApp(
//     ChangeNotifierProvider(
//         create: (context)=> LiftsViewModel(),
//         child: MaterialApp(
//           title: 'TravelMate',
//           home: const HomePage(),
//         ),
//     )
//
//   );
// }

