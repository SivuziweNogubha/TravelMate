
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifts_app/model/user_model.dart';
import 'package:lifts_app/pages/profile.dart';
import 'package:provider/provider.dart';

import '../../model/user_provider.dart';
import '../../utils/important_constants.dart';


PreferredSizeWidget defaultAppBar(BuildContext context, String? screenName) {
  final userProvider = Provider.of<UserProvider>(context);
  final user = userProvider.user;

  return AppBar(                  
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'TravelMate',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
            fontFamily: 'Aeonik',
          ),
        ),
        const SizedBox(width: 8),
        Image.asset(
          color: Colors.white,
          'assets/icons/TravelMate.png',
          width: 44,
          height: 74,
        ),
      ],
    ),
    centerTitle: true,
    backgroundColor: AppColors.backgroundColor,

    elevation: 0,
    actions: [
      // Icon(Icons.ac_unit_outlined),
      if (user != null && user.uid != null)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: user.uid!),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage('assets/profile.png') as ImageProvider,
              child: user.photoURL == null
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
          ),
        ),
    ],
  );
}