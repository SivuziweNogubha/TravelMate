import 'package:flutter/cupertino.dart';

import '../../utils/important_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialWidget extends StatelessWidget {
 final VoidCallback onPressed;

  SocialWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Button
        GestureDetector(
          onTap: () {
            onPressed;
          },
          child: Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/google.svg',
              height: 5,
              width: 5,
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}