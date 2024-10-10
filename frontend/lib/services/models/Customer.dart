import 'package:flutter/material.dart';
import '../sharedPreferences/prefsAuth.dart';
import '../API/customer.dart';

class Bags {
  final int? weight;
  final int? number;

  Bags({required this.weight, required this.number});

  factory Bags.fromJson(Map<String, dynamic> json) {
    return Bags(
      weight: json['weight'],
      number: json['number'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'number': number,
    };
  }
}

class Containers {
  final int? capacity;
  final int? number;

  Containers({required this.capacity, required this.number});

  factory Containers.fromJson(Map<String, dynamic> json) {
    return Containers(
      capacity: json['capacity'],
      number: json['number'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'capacity': capacity,
      'number': number,
    };
  }
}

class Customer {
  final int? id;
  final String name;
  final String phone;
  final Wilaya state;
  final String zone;
  final List<Bags>? bags;
  final List<Containers>? containers;
  final int daysGone;
  final int oliveType;
  final bool isPrinted;

  Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.state,
    required this.zone,
    this.containers,
    this.bags,
    required this.daysGone,
    required this.oliveType,
    this.isPrinted = false,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    var bagsList = json['bags'] as List?;
    List<Bags>? bags = bagsList?.map((i) => Bags.fromJson(i)).toList();
    var containersList = json['containers'] as List?;
    List<Containers>? containers =
        containersList?.map((i) => Containers.fromJson(i)).toList();
    return Customer(
      id: json['id'],
      name: json['full_name'],
      phone: json['phone'],
      state: Wilaya.fromJson(json['state']),
      zone: json['zone'],
      bags: bags,
      containers: containers,
      oliveType: json['olive_type'],
      daysGone: json['days_gone'],
      isPrinted: json['is_printed'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'phone': phone,
      'state': state.id,
      'zone': zone,
      'bags': bags?.map((bag) => bag.toJson()).toList(),
      'containers': containers?.map((container) => container.toJson()).toList(),
      'olive_type': oliveType,
      'days_gone': daysGone,
      'is_printed': isPrinted,
    };
  }
}

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
