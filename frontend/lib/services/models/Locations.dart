import 'package:flutter/material.dart';
import '../sharedPreferences/prefsAuth.dart';
import '../API/locations.dart';

class Wilaya {
  final int id;
  final String name;
  Wilaya({required this.id, required this.name});

  factory Wilaya.fromJson(Map<String, dynamic> json) {
    return Wilaya(
      id: json['id'],
      name: json['state'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StatesProvider extends ChangeNotifier {
  List<Wilaya>? states;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StatesProvider() {
    _initializeStates();
  }
  Future<void> _initializeStates() async {
    final token = await getToken();
    states = await getStates(token);
    _isLoading = false;
    notifyListeners();
  }
}

// class Zone {
//   final int id;
//   final String name;
//   Zone({required this.id, required this.name});

//   factory Zone.fromJson(Map<String, dynamic> json) {
//     return Zone(
//       id: json['id'],
//       name: json['state'],
//     );
//   }

//   // Method to convert a Company object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }

// class ZonesProvider extends ChangeNotifier {
//   List<Zone>? zones;
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Future<void> initializeZones(String state) async {
//     final token = await getToken();
//     zones = await getZones(token, state);
//     _isLoading = false;
//     notifyListeners();
//   }
// }
