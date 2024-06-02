import 'package:flutter/foundation.dart';
import 'package:lifts_app/model/user_model.dart';


class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
