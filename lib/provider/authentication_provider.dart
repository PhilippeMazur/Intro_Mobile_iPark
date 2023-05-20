import 'package:flutter/material.dart';

import '../model/account.dart';

class AuthenticationProvider extends ChangeNotifier {
  Account? _user;

  Account? get user => _user;

  bool get loggedIn => _user != null;

  logout() {
    _user = null;
    notifyListeners();
  }

  login(Account newName) {
    _user = newName;
    notifyListeners();
  }
}
