import 'package:flutter/material.dart';
import '../API/auth.dart';
import '../sharedPreferences/prefsAuth.dart';

class User {
  final int id;
  final String username;
  final bool isSuperUser;
  final bool isStaff;

  User({
    required this.username,
    required this.id,
    required this.isSuperUser,
    required this.isStaff,
  });

  // Factory constructor to create a User from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      isSuperUser: json['is_superuser'],
      isStaff: json['is_staff'],
    );
  }

  // Method to convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'is_superuser': isSuperUser,
      'is_staff': isStaff,
    };
  }
}

class UserProvider with ChangeNotifier {
  User? user;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  UserProvider() {
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    String? token = await getToken();
    final u = await getUser(token);
    user = u;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNewUser(User u) async {
    user = u;
    notifyListeners();
  }
}
