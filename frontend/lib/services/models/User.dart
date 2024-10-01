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

  

  Future<void> initializeProducts() async {
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

  UsersWithNoPermisson() {
    _initializeUsers();
  }

  Future<void> _initializeUsers() async {
    String? token = await getToken();
    final u = await getStaffUsers(token);
    if (u != null) {
      users.addAll(u);
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
  Future<void> GivePermission(User user) async {
    String? token = await getToken();

    final res = await addUserToStaff(token, user.id);
    if (res) {
      users.remove(user);
    }
    notifyListeners();
  }


}
