import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingAnimation extends StatelessWidget {
  final String animationPath;
  final double width;
  final double height;

  const CustomLoadingAnimation({
    Key? key,
    required this.animationPath,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        animationPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
