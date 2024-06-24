import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import 'package:lifts_app/model/lifts_view_model.dart';
// import 'package:lifts_app/pages/home.dart';
import 'package:lifts_app/pages/onboarding/login_screen.dart';
import 'package:lifts_app/pages/splash_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifts_app/repository/lifts_repository.dart';
import 'package:lifts_app/view_models/profile_view_model.dart' ;
import 'package:lifts_app/view_models/ride_view_model.dart';
import 'package:provider/provider.dart';
import 'package:lifts_app/model/lifts_view_model.dart'as viewnodel;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'model/user_provider.dart';





Color primary = Color(0xff072227);
Color secondary = Color(0xff35858B);
Color primaryLight = Color(0xff4FBDBA);
Color secondaryLight = Color(0xffAEFEFF);



class pallette {
  static const MaterialColor primary =
  const MaterialColor(0xff072227, const <int, Color>{});
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "./.env");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print('Environment variables loaded: ${dotenv.env}');

  // await GoogleMaps.init();
  await Firebase.initializeApp();
  final currentUser = FirebaseAuth.instance.currentUser;
  final userId = currentUser?.uid;


  runApp(
    MultiProvider(
      providers: [
        Provider<LiftsRepository>( // Provide LiftsRepository
          create: (context) => LiftsRepository(),
        ),
        // ChangeNotifierProvider( // Inject LiftsRepository into LiftsViewModel
        //   create: (context) => viewnodel.LiftsViewModel(Provider.of<LiftsRepository>(context)),
        //
        // ),
        if (userId != null)
          ChangeNotifierProvider(create: (_) => ProfileViewModel(userId)),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LiftsViewModel()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "TravelMate",
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const splash_screen(),
      ),
    ),

  );
}

class MyApp extends StatelessWidget {
  //
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image(
                image: AssetImage("images/logo.png"),
                width: 105,
                height: 105,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "Welcome to\nTravelMate Login Portal",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: ButtonTheme(
                  minWidth: 200,
                  child: ElevatedButton(
                    // textColor: Colors.white,
                    // color: primary,
                    child: Text("Logout",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      logout(context);
                      Fluttertoast.showToast(msg: "Logged Out!");
                    },
                    // shape: new RoundedRectangleBorder(
                    //   borderRadius: new BorderRadius.circular(30.0),
                    // ),
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "An e-hailing app /uber replica application\n"
                        "with firebase authentication",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Creating a Logout Function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => login_screen()));
  }
}

// Creating an Alert Dialog for the Info button in App Bar
showAlertDialog(BuildContext context) {
  // Setting up the button
  Widget okButton = TextButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // Set up the Alert Dialog
  AlertDialog alertDialog = AlertDialog(
    title: Text("Student Login Application"),
    content: Text(
        "This is the simple Student login application with firebase authentication\n"
            "\nDeveloped by\n"
            "Ruban Gino Singh - URK20CS2001\n"
            "Joewin Sam - URK20CS1054\n"
            "Magrin Fenisha - URK20CS1042\n"
            "Jerusha - URK20CS1035\n"),
    actions: [okButton],
  );

  // Show the Dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:lifts_app/pages/onboarding/login_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:lifts_app/pages/splash_screen.dart';
// import 'package:lifts_app/repository/lifts_repository.dart';
// import 'package:lifts_app/view_models/profile_view_model.dart';
// import 'package:lifts_app/view_models/ride_view_model.dart';
// import 'package:lifts_app/model/lifts_view_model.dart' as viewnodel;
// import 'package:lifts_app/model/user_provider.dart';
//
// Color primary = Color(0xff072227);
// Color secondary = Color(0xff35858B);
// Color primaryLight = Color(0xff4FBDBA);
// Color secondaryLight = Color(0xffAEFEFF);
//
// class pallette {
//   static const MaterialColor primary = MaterialColor(0xff072227, <int, Color>{});
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
// }
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: "./.env");
//   await Firebase.initializeApp();
//   //   await Firebase.initializeApp();
//   final currentUser = FirebaseAuth.instance.currentUser;
//   final userId = currentUser?.uid;
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   final AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   final InitializationSettings initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<LiftsRepository>(
//           create: (context) => LiftsRepository(),
//         ),
//         if (FirebaseAuth.instance.currentUser != null)
//           ChangeNotifierProvider(
//               create: (_) =>
//                   ProfileViewModel(FirebaseAuth.instance.currentUser!.uid)),
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (_) => viewnodel.LiftsViewModel(Provider.of<LiftsRepository>(context))),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: "TravelMate",
//         theme: ThemeData(
//           primarySwatch: Colors.blueGrey,
//         ),
//         home: const splash_screen(),
//       ),
//     );
//   }
//
//   // Creating a Logout Function
//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => login_screen()));
//   }
// }
//
// // Creating an Alert Dialog for the Info button in App Bar
// showAlertDialog(BuildContext context) {
//   // Setting up the button
//   Widget okButton = TextButton(
//     child: Text("Ok"),
//     onPressed: () {
//       Navigator.pop(context);
//     },
//   );
//
//   // Set up the Alert Dialog
//   AlertDialog alertDialog = AlertDialog(
//     title: Text("Student Login Application"),
//     content: Text(
//         "This is the simple Student login application with firebase authentication\n"
//             "\nDeveloped by\n"
//             "Ruban Gino Singh - URK20CS2001\n"
//             "Joewin Sam - URK20CS1054\n"
//             "Magrin Fenisha - URK20CS1042\n"
//             "Jerusha - URK20CS1035\n"),
//     actions: [okButton],
//   );
//
//   // Show the Dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alertDialog;
//     },
//   );
// }
//
// class splash_screen extends StatefulWidget {
//   const splash_screen({Key? key}) : super(key: key);
//
//   @override
//   _splash_screenState createState() => _splash_screenState();
// }
//
// class _splash_screenState extends State<splash_screen> {
//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//     _configureFirebaseMessaging();
//   }
//
//   void _requestPermission() {
//     FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//   }
//
//   void _configureFirebaseMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               '@mipmap/ic_launcher',
//               'High Importance Notifications',
//               // 'This channel is used for important notifications.',
//               importance: Importance.high,
//               icon: '@mipmap/ic_launcher',
//             ),
//           ),
//         );
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Handle notification tapped logic here
//     });
//
//     _saveTokenToDatabase();
//   }
//
//   Future<void> _saveTokenToDatabase() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null && token != null) {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//         'fcmToken': token,
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
