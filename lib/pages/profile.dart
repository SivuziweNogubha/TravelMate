// import 'dart:io';
// import 'dart:ui';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:lifts_app/model/user_provider.dart';
// import 'package:lifts_app/pages/onboarding/reset_password.dart';
// import 'package:lifts_app/pages/wallet_page.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:lifts_app/view_models/profile_view_model.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add this import for Google Maps
//
// import '../utils/important_constants.dart';
// import 'onboarding/login_screen.dart';
//
// class ProfilePage extends StatelessWidget {
//   final String uid;
//
//   const ProfilePage({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ProfileViewModel(uid),
//       child: ProfilePageContent(uid: uid),
//     );
//   }
// }
//
// class ProfilePageContent extends StatefulWidget {
//   final String uid;
//
//   const ProfilePageContent({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   _ProfilePageContentState createState() => _ProfilePageContentState();
// }
//
// class _ProfilePageContentState extends State<ProfilePageContent> {
//   File? _imageFile;
//   final picker = ImagePicker();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Position? _currentPosition;
//   late GoogleMapController _googleMapController;
//
//
//
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       print('Error getting current location: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//
//
//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//
//       // Upload the image to Firebase Storage
//       print('User UID: ${widget.uid}');
//
//       // My storage Bucket at firestore
//       Reference storageReference = FirebaseStorage.instance
//           .refFromURL('gs://e-hailing-94d2c.appspot.com')
//           .child('profile_images/${widget.uid}');
//
//       print('Storage reference path: ${storageReference.fullPath}');
//
//       UploadTask uploadTask = storageReference.putFile(_imageFile!);
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         print('Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
//       }, onError: (error) {
//         print('Error uploading image: $error');
//       });
//       await uploadTask;
//       String downloadURL = await storageReference.getDownloadURL();
//       FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
//         'photoURL': downloadURL,
//       });
//     }
//   }
//
//   Future<void> _deleteImage() async {
//     FirebaseStorage.instance.ref().child('profile_images/${widget.uid}').delete();
//     FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
//       'photoURL': null,
//     });
//   }
//
//   void _showDeleteDialog(BuildContext context) {
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Image'),
//           content: Text('Are you sure you want to delete the image?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _deleteImage();
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final user = userProvider.user;
//     return
//       SafeArea(
//         child: Scaffold(
//           body: Stack(
//             children: [
//               _currentPosition != null
//                   ? GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(
//                     _currentPosition!.latitude,
//                     _currentPosition!.longitude,
//                   ),
//                   zoom: 15,
//                 ),
//                 onMapCreated: (GoogleMapController controller) {
//                   _googleMapController = controller;
//                 },
//               )
//                   : const Center(
//                 child: CircularProgressIndicator(),
//               ),
//               Positioned.fill(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                   child: Container(
//                     color: Colors.black.withOpacity(0.3),
//                   ),
//                 ),
//               ),
//               StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance.collection('users').doc(widget.uid).snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//
//                   var userData = snapshot.data!.data() as Map<String, dynamic>;
//
//                   return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
//                   child: Center(
//                       child: ListView(
//                         padding: EdgeInsets.all(20),
//                         children: [
//                           Center(
//                             child: Stack(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 50,
//                                   backgroundImage: userData['photoURL'] != null
//                                       ? NetworkImage(userData['photoURL'])
//                                       : _imageFile != null
//                                       ? FileImage(_imageFile!)
//                                       : AssetImage('assets/icons/camera.png') as ImageProvider,
//                                   child: _imageFile == null && userData['photoURL'] == null
//                                       ? Icon(Icons.person, size: 50)
//                                       : null,
//
//                                 ),
//
//                                 Positioned(
//                                   bottom: 0,
//                                   right: 0,
//                                   child: InkWell(
//                                     onTap: _uploadImage,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.edit,
//                                         color: Colors.blue,
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 if (userData['photoURL'] != null)
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: InkWell(
//                                       onTap: () => _showDeleteDialog(context),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children:[
//                               Text('${userData['firstName']} ${userData['lastName']}',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.none,
//                                   fontFamily: 'Aeonik',
//                                 ),
//                               )
//                             ]
//                           ),
//                           SizedBox(height: 20),
//                           ListTile(
//                             title: Row(
//                               children: [
//                                 ImageIcon(
//                                   AssetImage('assets/icons/mail.png'),
//                                   size: 24.0,
//                                 ),
//                                 SizedBox(width: 8.0),
//                                 Text(
//                                   'E-mail:',
//                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                             subtitle: Text(userData['email'] ?? 'N/A'),
//                           ),
//
//
//                           GestureDetector(
//                             onTap: () async {
//                               _showLogoutDialog(context, userProvider);
//                             },
//                             child: Container(
//                               height: 60,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: AppColors.buttonColor,
//                                 borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
//                                 border: Border.all(
//                                   color: AppColors.enabledBorderColor,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset(
//                                     "assets/icons/logout.svg",
//                                     color: Colors.white,
//                                     height: 20,
//                                   ),
//                                   const SizedBox(width: 15),
//                                   const Text(
//                                     "Logout",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.normal,
//                                       decoration: TextDecoration.none,
//                                       fontFamily: 'Aeonik',
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (_) => ResetPasswordPage())
//                               );
//                             },
//                             child: Container(
//                               height: 60,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: AppColors.buttonColor,
//                                 borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
//                                 border: Border.all(
//                                   color: AppColors.enabledBorderColor,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset(
//                                     "assets/icons/reset.svg",
//                                     color: Colors.white,
//                                     height: 20,
//                                   ),
//                                   const SizedBox(width: 15),
//                                   const Text(
//                                     "Reset Password",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.normal,
//                                       decoration: TextDecoration.none,
//                                       fontFamily: 'Aeonik',
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           GestureDetector(
//                             onTap: () async {
//                               await Provider.of<ProfileViewModel>(context, listen: false).deleteAccount();
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(builder: (_) => const login_screen()),
//                               );
//                             },
//                             child: Container(
//                               height: 60,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
//                                 border: Border.all(
//                                   color: AppColors.enabledBorderColor,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset(
//                                     "assets/icons/delete.svg",
//                                     color: Colors.white,
//                                     height: 20,
//                                   ),
//                                   const SizedBox(width: 15),
//                                   const Text(
//                                     "Delete Account",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.normal,
//                                       decoration: TextDecoration.none,
//                                       fontFamily: 'Aeonik',
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 8,
//                             right: 8,
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(builder: (context) => WalletPage()),
//                                 );
//                               },
//                               child: ImageIcon(
//                                 AssetImage('assets/icons/settings.png'),
//                                 size: 24.0,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//
//                         ],
//
//                       ),
//
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//   }
//
//   Future<void> _showLogoutDialog(BuildContext context, UserProvider userProvider) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Logout'),
//               onPressed: () async {
//                 await Provider.of<ProfileViewModel>(context, listen: false).signOut();
//                 userProvider.clearUser();
//                 // Navigator.of(context).pop();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const login_screen()),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// // import 'dart:io';
// // import 'dart:ui';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:lifts_app/model/user_provider.dart';
// // import 'package:lifts_app/pages/onboarding/reset_password.dart';
// // import 'package:provider/provider.dart';
// // import 'package:lifts_app/view_models/profile_view_model.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add this import for Google Maps
// // import 'package:lottie/lottie.dart'; // Import Lottie for animations
// //
// // import '../utils/important_constants.dart';
// // import 'onboarding/login_screen.dart';
// // import 'wallet_page.dart'; // Import WalletPage
// //
// // class ProfilePage extends StatelessWidget {
// //   final String uid;
// //
// //   const ProfilePage({Key? key, required this.uid}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ChangeNotifierProvider(
// //       create: (_) => ProfileViewModel(uid),
// //       child: ProfilePageContent(uid: uid),
// //     );
// //   }
// // }
// //
// // class ProfilePageContent extends StatefulWidget {
// //   final String uid;
// //
// //   const ProfilePageContent({Key? key, required this.uid}) : super(key: key);
// //
// //   @override
// //   _ProfilePageContentState createState() => _ProfilePageContentState();
// // }
// //
// // class _ProfilePageContentState extends State<ProfilePageContent> {
// //   File? _imageFile;
// //   final picker = ImagePicker();
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //
// //   Position? _currentPosition;
// //   late GoogleMapController _googleMapController;
// //
// //   Future<void> _getCurrentLocation() async {
// //     try {
// //       Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //       );
// //       setState(() {
// //         _currentPosition = position;
// //       });
// //     } catch (e) {
// //       print('Error getting current location: $e');
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getCurrentLocation();
// //   }
// //
// //   Future<void> _uploadImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
// //
// //     if (pickedFile != null) {
// //       setState(() {
// //         _imageFile = File(pickedFile.path);
// //       });
// //
// //       // Upload the image to Firebase Storage
// //       print('User UID: ${widget.uid}');
// //
// //       // My storage Bucket at firestore
// //       Reference storageReference = FirebaseStorage.instance
// //           .refFromURL('gs://e-hailing-94d2c.appspot.com')
// //           .child('profile_images/${widget.uid}');
// //
// //       print('Storage reference path: ${storageReference.fullPath}');
// //
// //       UploadTask uploadTask = storageReference.putFile(_imageFile!);
// //       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
// //         print('Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
// //       }, onError: (error) {
// //         print('Error uploading image: $error');
// //       });
// //       await uploadTask;
// //       String downloadURL = await storageReference.getDownloadURL();
// //       FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
// //         'photoURL': downloadURL,
// //       });
// //     }
// //   }
// //
// //   Future<void> _deleteImage() async {
// //     FirebaseStorage.instance.ref().child('profile_images/${widget.uid}').delete();
// //     FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
// //       'photoURL': null,
// //     });
// //   }
// //
// //   void _showDeleteDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Delete Image'),
// //           content: Text('Are you sure you want to delete the image?'),
// //           actions: <Widget>[
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close dialog
// //               },
// //               child: Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 _deleteImage();
// //                 Navigator.of(context).pop(); // Close dialog
// //               },
// //               child: Text('Delete'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final userProvider = Provider.of<UserProvider>(context);
// //     final user = userProvider.user;
// //     return SafeArea(
// //       child: Scaffold(
// //         body: Stack(
// //           children: [
// //             _currentPosition != null
// //                 ? GoogleMap(
// //               initialCameraPosition: CameraPosition(
// //                 target: LatLng(
// //                   _currentPosition!.latitude,
// //                   _currentPosition!.longitude,
// //                 ),
// //                 zoom: 15,
// //               ),
// //               onMapCreated: (GoogleMapController controller) {
// //                 _googleMapController = controller;
// //               },
// //             )
// //                 : const Center(
// //               child: CircularProgressIndicator(),
// //             ),
// //             Positioned.fill(
// //               child: BackdropFilter(
// //                 filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
// //                 child: Container(
// //                   color: Colors.black.withOpacity(0.3),
// //                 ),
// //               ),
// //             ),
// //             StreamBuilder<DocumentSnapshot>(
// //               stream: FirebaseFirestore.instance.collection('users').doc(widget.uid).snapshots(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) {
// //                   return Center(child: CircularProgressIndicator());
// //                 }
// //
// //                 var userData = snapshot.data!.data() as Map<String, dynamic>;
// //
// //                 return Card(
// //                   margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
// //                   child: Center(
// //                     child: ListView(
// //                       padding: EdgeInsets.all(20),
// //                       children: [
// //                         Center(
// //                           child: Stack(
// //                             children: [
// //                               CircleAvatar(
// //                                 radius: 50,
// //                                 backgroundImage: userData['photoURL'] != null
// //                                     ? NetworkImage(userData['photoURL'])
// //                                     : _imageFile != null
// //                                     ? FileImage(_imageFile!)
// //                                     : AssetImage('assets/icons/camera.png') as ImageProvider,
// //                                 child: _imageFile == null && userData['photoURL'] == null
// //                                     ? Icon(Icons.person, size: 50)
// //                                     : null,
// //                               ),
// //                               Positioned(
// //                                 bottom: 0,
// //                                 right: 0,
// //                                 child: InkWell(
// //                                   onTap: _uploadImage,
// //                                   child: Container(
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.white,
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                     child: Icon(
// //                                       Icons.edit,
// //                                       color: Colors.blue,
// //                                       size: 20,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                               if (userData['photoURL'] != null)
// //                                 Positioned(
// //                                   top: 0,
// //                                   right: 0,
// //                                   child: InkWell(
// //                                     onTap: () => _showDeleteDialog(context),
// //                                     child: Container(
// //                                       decoration: BoxDecoration(
// //                                         color: Colors.white,
// //                                         shape: BoxShape.circle,
// //                                       ),
// //                                       child: Icon(
// //                                         Icons.delete,
// //                                         color: Colors.red,
// //                                         size: 20,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                             ],
// //                           ),
// //                         ),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text(
// //                               '${userData['firstName']} ${userData['lastName']}',
// //                               style: TextStyle(
// //                                 color: Colors.black,
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.bold,
// //                                 decoration: TextDecoration.none,
// //                                 fontFamily: 'Aeonik',
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         SizedBox(height: 20),
// //                         ListTile(
// //                           title: Row(
// //                             children: [
// //                               ImageIcon(
// //                                 AssetImage('assets/icons/mail.png'),
// //                                 size: 24.0,
// //                               ),
// //                               SizedBox(width: 8.0),
// //                               Text(
// //                                 'E-mail:',
// //                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                               ),
// //                             ],
// //                           ),
// //                           subtitle: Text(userData['email'] ?? 'N/A'),
// //                         ),
// //                         GestureDetector(
// //                           onTap: () {
// //                             Navigator.of(context).push(
// //                               MaterialPageRoute(builder: (context) => WalletPage()),
// //                             );
// //                           },
// //                           child: Column(
// //                             children: [
// //                               Lottie.asset(
// //                                 'assets/animations/wallet.json',
// //                                 height: 200,
// //                                 width: 200,
// //                               ),
// //                               Text(
// //                                 'Wallet Settings',
// //                                 style: TextStyle(
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         GestureDetector(
// //                           onTap: () async {
// //                             _showLogoutDialog(context, userProvider);
// //                           },
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               SvgPicture.asset(
// //                                 'assets/icons/logout.svg',
// //                                 height: 24,
// //                                 width: 24,
// //                                 color: Colors.blue,
// //                               ),
// //                               SizedBox(width: 8),
// //                               Text(
// //                                 'Logout',
// //                                 style: TextStyle(
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Colors.blue,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Logout'),
// //           content: Text('Are you sure you want to logout?'),
// //           actions: <Widget>[
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close dialog
// //               },
// //               child: Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () async {
// //                 await Provider.of<ProfileViewModel>(context, listen: false).signOut();
// //                 // await userProvider.logout();
// //                 Navigator.of(context).pop();
// //                 Navigator.of(context).pushReplacement(
// //                   MaterialPageRoute(builder: (context) => login_screen()),
// //                 );
// //               },
// //               child: Text('Logout'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifts_app/model/user_provider.dart';
import 'package:lifts_app/pages/onboarding/reset_password.dart';
import 'package:provider/provider.dart';
import 'package:lifts_app/view_models/profile_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add this import for Google Maps
import 'package:lottie/lottie.dart'; // Import Lottie for animations

import '../utils/important_constants.dart';
import 'onboarding/login_screen.dart';
import 'wallet_page.dart'; // Import WalletPage

class ProfilePage extends StatelessWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(uid),
      child: ProfilePageContent(uid: uid),
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  final String uid;

  const ProfilePageContent({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  File? _imageFile;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Position? _currentPosition;
  late GoogleMapController _googleMapController;

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage
      print('User UID: ${widget.uid}');

      // My storage Bucket at firestore
      Reference storageReference = FirebaseStorage.instance
          .refFromURL('gs://e-hailing-94d2c.appspot.com')
          .child('profile_images/${widget.uid}');

      print('Storage reference path: ${storageReference.fullPath}');

      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      }, onError: (error) {
        print('Error uploading image: $error');
      });
      await uploadTask;
      String downloadURL = await storageReference.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'photoURL': downloadURL,
      });
    }
  }

  Future<void> _deleteImage() async {
    FirebaseStorage.instance.ref().child('profile_images/${widget.uid}').delete();
    FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
      'photoURL': null,
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete the image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteImage();
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Image.asset(
                  'assets/pictures/dark_map.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Optional overlay to adjust brightness/contrast
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;

                return Card(
                  color: AppColors.backgroundColor,
                  margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                  child: Center(
                    child: Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.all(20),
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: userData['photoURL'] != null
                                        ? NetworkImage(userData['photoURL'])
                                        : _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : AssetImage('assets/icons/camera.png') as ImageProvider,
                                    child: _imageFile == null && userData['photoURL'] == null
                                        ? Icon(Icons.person, size: 50)
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _uploadImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (userData['photoURL'] != null)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () => _showDeleteDialog(context),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${userData['name']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Aeonik',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ListTile(
                              title: Row(
                                children: [
                                  ImageIcon(
                                    color: Colors.white,
                                    AssetImage('assets/icons/mail.png'),
                                    size: 24.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'E-mail:',
                                    style: TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Text(userData['email'] ?? 'N/A'),
                              subtitleTextStyle: TextStyle(color: Colors.white),
                            ),
                          GestureDetector(
                            onTap: () async {
                              _showLogoutDialog(context, userProvider);
                            },
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                                border: Border.all(
                                  color: AppColors.enabledBorderColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/logout.svg",
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontFamily: 'Aeonik',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ResetPasswordPage())
                              );
                            },
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                                border: Border.all(
                                  color: AppColors.enabledBorderColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/reset.svg",
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    "Reset Password",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontFamily: 'Aeonik',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () async {
                              await Provider.of<ProfileViewModel>(context, listen: false).deleteAccount();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const login_screen()),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(AppValues.largeBorderRadius),
                                border: Border.all(
                                  color: AppColors.enabledBorderColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/delete_icon.svg",
                                    color: Colors.white,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontFamily: 'Aeonik',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(builder: (context) => WalletPage()),
                              // );
                            },
                            child: ImageIcon(
                              AssetImage('assets/icons/settings.png'),
                              size: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // await userProvider.logout();
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => login_screen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
