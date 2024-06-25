import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'AutoComplete.dart';

class LocationWidget extends StatelessWidget {
  final TextEditingController departureController;
  final TextEditingController destinationController;
  final String icon;

  LocationWidget({
    required this.departureController,
    required this.destinationController,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/uber_line.svg',
          height: 70,
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            children: [
              AutoCompleteTextField(
                controller: departureController,
                hintText: "Your Location?",
                icon: icon,
              ),
              const SizedBox(height: 7),
              AutoCompleteTextField(
                controller: destinationController,
                hintText: "Where to?",
                icon: icon,
              ),
            ],
          ),
        )
      ],
    );
  }
}
