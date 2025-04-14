import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> initializeUser() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<void> updateUser(User? user) async {
    _user = user;
    notifyListeners();
  }
}