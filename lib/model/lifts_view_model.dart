
import 'package:flutter/foundation.dart';
import 'package:lifts_app/repository/lifts_repository.dart';

// ///Contains the relevant lifts data for our views
// class LiftsViewModel extends  ChangeNotifier {
//   //TODO keep track of loaded Lifts and notify views on changes
//
// }

import 'package:flutter/material.dart';

import 'lift.dart'; // Ensure you have imported the Lift class

class LiftsViewModel extends ChangeNotifier {

  List<Lift> _lifts = [];


  List<Lift> get lifts => _lifts;

  final LiftsRepository _repository;

  LiftsViewModel(this._repository);

  // ... existing methods

  Future<void> updateLift(String liftId, Lift updatedLift) async {
    await _repository.updateLift(updatedLift);
  }

  void addLift(Lift lift) {
    _lifts.add(lift);
    notifyListeners();
  }

  void removeLift(String liftId) {
    _lifts.removeWhere((lift) => lift.liftId == liftId);
    notifyListeners();
  }


  //
  // void updateLift(Lift updatedLift) {
  //   int index = _lifts.indexWhere((lift) => lift.liftId == updatedLift.liftId);
  //   if (index != -1) {
  //     _lifts[index] = updatedLift;
  //     notifyListeners();
  //   }
  // }

  void loadLifts(List<Lift> lifts) {
    _lifts = lifts;
    notifyListeners();
  }
}
