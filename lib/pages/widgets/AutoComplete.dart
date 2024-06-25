import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../utils/important_constants.dart';
import 'package:flutter_svg/svg.dart';

class AutoCompleteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String icon;

  AutoCompleteTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textStyle: TextStyle(color: Colors.white),
      textEditingController: controller,
      googleAPIKey: dotenv.env['GOOGLE_CLOUD_MAP_ID']!,
      inputDecoration: InputDecoration(
        prefixIcon: ImageIcon(
          AssetImage(icon),
          size: 24,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      countries: ["za"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (prediction) {
        print("placeDetails: ${prediction.lng}");
      },
      itemClick: (prediction) {
        controller.text = prediction.description!;
      },
      itemBuilder: (context, index, Prediction prediction) =>
          _buildPredictionItem(context, prediction, controller),
    );
  }

  Widget _buildPredictionItem(BuildContext context, Prediction prediction, TextEditingController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.text = prediction.description!;
            // Close the suggestions - you might need to implement this based on the package's capabilities
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/location_icon.svg", height: 24),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.structuredFormatting?.mainText ?? prediction.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        prediction.structuredFormatting?.secondaryText ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.highlightColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: AppColors.enabledBorderColor, thickness: 1),
      ],
    );
  }
}
