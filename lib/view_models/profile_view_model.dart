import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lifts_app/model/user_model.dart';
import 'package:lifts_app/repository/lifts_repository.dart';

import '../src/firebase_authentication.dart';

class ProfileViewModel extends ChangeNotifier {
  final String _userID;
  ProfileViewModel(this._userID);

  final LiftsRepository _liftRepository = LiftsRepository();
  FirebaseAuthService authService = FirebaseAuthService();

  Future<void> deleteAccount() async {
    await _liftRepository.deleteUserData(_userID);
    await authService.deleteUser();
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}
