import 'package:flutter/material.dart';
import '../sharedPreferences/prefsAuth.dart';

class TokenProvider with ChangeNotifier {
  String? token;
  bool _isLoading = true;

  bool get isLoading => _isLoading;


  Future<void> initializeToken() async {
    token = await getToken();
    _isLoading = false;
    notifyListeners();
  }
}
