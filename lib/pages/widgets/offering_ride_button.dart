import 'package:flutter/material.dart';

class OfferRideButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  OfferRideButtonWidget({required this.onPressed});
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Positioned(
  //     bottom: 16.0,
  //     left: 0,
  //     right: 0,
  //     child: Center(
  //       child: ElevatedButton.icon(
  //         onPressed: onPressed,
  //         icon: ImageIcon(
  //           AssetImage('assets/icons/car_passengers.png'),
  //           color: Colors.white, // Set the icon color to white
  //         ),
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.black, // Set the button background color to black
  //           side: BorderSide(color: Colors.blueGrey, width: 2), // Bluish outline
  //         ),
  //         label: Text(
  //           'Offer Ride',
  //           style: TextStyle(color: Colors.white), // Set the text color to white
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          key: Key('offer_ride_button'),
          onPressed: onPressed,
          icon: ImageIcon(
            AssetImage('assets/icons/car_passengers.png'),
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            side: BorderSide(color: Colors.blueGrey, width: 2),
          ),
          label: Text(
            'Offer Ride',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
