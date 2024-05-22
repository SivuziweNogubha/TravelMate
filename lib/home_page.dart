// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' // new
hide EmailAuthProvider, PhoneAuthProvider;    // new
import 'package:flutter/material.dart';           // new
import 'package:provider/provider.dart';          // new
import 'app_state.dart';                          // new
import 'src/authentication.dart';                 // new
import 'src/widgets.dart';
// import 'guest_book.dart';
// import 'package:lifts_app/model/fuel_price.dart';
// import 'package:widgets_app/pages/settings.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Fuel App'),
      ),
      body: ListView(
        children: <Widget>[
          // Image.asset('assets/codelab.png'),
          // const SizedBox(height: 8),
          // const IconAndDetail(Icons.calendar_today, 'October 30'),
          // const IconAndDetail(Icons.location_city, 'San Francisco'),/**/
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
            Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          // const Header("Home"),
          const Paragraph(
            '',
          ),

          // const Header('Discussion'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,

            ),
          ),
        ],
      ),
    );
  }
}

  //
  // Widget _buildPriceHistoryList(BuildContext context,
  //     FuelPriceModel fuelPriceModel) {
  //   return ListView.builder(
  //       itemCount: 20,
  //       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
  //       itemBuilder: (listBuildContext, index) {
  //         if (index.isEven && !fuelPriceModel.showDieselPrice) {
  //           return Container();
  //         }
  //         if (!index.isEven && !fuelPriceModel.showPetrolPrice) {
  //           return Container();
  //         }
  //         String message = index.isEven
  //             ? 'Diesel price changed to ${fuelPriceModel.currentDieselPrice -
  //             (index / 2).ceil()}'
  //             : 'Petrol price changed to ${fuelPriceModel.currentPetrolPrice -
  //             (index / 2).floor()}';
  //         return Padding(
  //             padding: const EdgeInsets.all(6.0),
  //             child: Text(
  //               message,
  //               textAlign: TextAlign.center,
  //             ));
  //       });
  // }

  // _openSettingsView(BuildContext context, FuelPriceModel fuelPriceModel) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             ChangeNotifierProvider.value(
  //                 value: fuelPriceModel,
  //                 child: const SettingsView()),
  //         fullscreenDialog: true),
  //   );
  // }


// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => FuelPriceModel(),
//       child: MaterialApp(
//         title: 'Mine',
//         home: const HomePage(), // Your HomePage widget
//       ),
//     ),
//   );
// }