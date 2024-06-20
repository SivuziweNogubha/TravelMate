import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../model/lift.dart';
import '../repository/lifts_repository.dart';
import '../repository/wallet_repo.dart';

class LiftsViewModel extends ChangeNotifier {
  final LiftsRepository _liftsRepository = LiftsRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();

  List<Lift> _lifts = [];
  bool _isLoading = false;

  List<Lift> get lifts => _lifts;
  bool get isLoading => _isLoading;

  LiftsViewModel() {
    fetchLifts();
  }


  Stream<QuerySnapshot> getJoinedLifts(String userId) {
    return _liftsRepository.getJoinedLifts(userId);
  }

  Future<void> cancelLift(String liftId, String userId) async {
    await _liftsRepository.cancelLift(liftId, userId);
    notifyListeners(); // Notify listeners if needed
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  Future<void> fetchLifts() async {
    _setLoading(true);
    try {
      String userId = _auth.currentUser!.uid;
      _lifts = await _liftsRepository.getUpcomingLiftsByUserId(userId);
    } catch (e) {
      logger.e('Error fetching lifts: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addLift(Lift lift) async {
    try {
      await _liftsRepository.createLift(lift);
      _lifts.add(lift);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding lift: $e');
    }
  }

  Future<void> updateLift(Lift lift) async {
    try {
      await _liftsRepository.updateLift(lift);
      int index = _lifts.indexWhere((l) => l.liftId == lift.liftId);
      if (index != -1) {
        _lifts[index] = lift;
        notifyListeners();
      }
    } catch (e) {
      logger.e('Error updating lift: $e');
    }
  }

  Future<void> deleteLift(String liftId) async {
    try {
      await _liftsRepository.deleteLift(liftId);
      _lifts.removeWhere((l) => l.liftId == liftId);
      notifyListeners();
    } catch (e) {
      logger.e('Error deleting lift: $e');
    }
  }

  Future<void> joinLift(BuildContext context, String liftId, WalletRepository walletRepository) async {
    try {
      String userId = _auth.currentUser!.uid;
      await _liftsRepository.joinLift(context, liftId, userId, walletRepository);
      fetchLifts();
    } catch (e) {
      logger.e('Error joining lift: $e');
    }
  }

  Future<void> completeLift(String liftId) async {
    try {
      await _liftsRepository.completeLift(liftId);
      fetchLifts(); // Refresh lifts after completion
    } catch (e) {
      logger.e('Error completing lift: $e');
    }
  }
  Stream<QuerySnapshot> getLiftsStreamByUserId(String userId) {
    return _firestore
        .collection('lifts')
        .where('offeredBy', isEqualTo: userId)
        .snapshots();
  }

  // Future<void> deleteLift(String liftId) async {
  //   await _firestore.collection('lifts').doc(liftId).delete();
  // }

  // Future<void> cancelLift(String liftId) async {
  //   try {
  //     await _liftsRepository.cancelLift(liftId);
  //     fetchLifts(); // Refresh lifts after cancellation
  //   } catch (e) {
  //     logger.e('Error canceling lift: $e');
  //   }
  // }

  Future<List<DocumentSnapshot>> searchRides(String destination, DateTime selectedDate, String currentUserId) async {
    try {
      return await _liftsRepository.searchRides(destination, selectedDate, currentUserId);
    } catch (e) {
      logger.e('Error searching rides: $e');
      return [];
    }
  }
}
