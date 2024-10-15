import 'package:flutter/material.dart';
import '../API/auth.dart';
import '../sharedPreferences/prefsAuth.dart';
import '../models/Company.dart';
import 'package:provider/provider.dart';

class User {
  final int id;
  final String username;
  final bool isSuperUser;
  final bool isStaff;
  final int? oliveType;

  User(
      {required this.username,
      required this.id,
      required this.isSuperUser,
      required this.isStaff,
      this.oliveType});

  // Factory constructor to create a User from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        isSuperUser: json['is_superuser'],
        isStaff: json['is_staff'],
        oliveType: json['olive_type']);
  }

  // Method to convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'is_superuser': isSuperUser,
      'is_staff': isStaff,
      'olive_type': oliveType
    };
  }
}

class UserProvider with ChangeNotifier {
  User? user;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> initializeProducts() async {
    _isLoading = true;

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

  Future<void> logoutUser() async {
    final token = await getToken();
    await logout(token);
    await removeToken();

    _isLoading = true;
    user = null;
    print('user');
    notifyListeners();
  }
}

class UsersWithNoPermisson with ChangeNotifier {
  List<User> users = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> initializeUsers() async {
    String? token = await getToken();
    final u = await getStaffUsers(token);
    if (u != null) {
      users.addAll(u.where((newUser) => !users
          .any((existingUser) => existingUser.username == newUser.username)));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> RemoveUser(User user) async {
    String? token = await getToken();

    final res = await deleteUser(token, user.id);
    if (res) {
      users.remove(user);
    }
    notifyListeners();
  }

  Future<void> GivePermission(User user, int oliveType) async {
    String? token = await getToken();

    final res = await addUserToStaff(token, user.id);
    await setUserOliveType(token, user.id, oliveType);
    if (res) {
      users.remove(user);
    }
    notifyListeners();
  }
}
