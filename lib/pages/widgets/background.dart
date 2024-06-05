import 'package:flutter/material.dart';

BoxDecoration appBackground() {
  return const BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/background.png"),
        fit: BoxFit.cover
    ),
  );
}