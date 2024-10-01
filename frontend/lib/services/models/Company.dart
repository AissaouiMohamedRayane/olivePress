import 'package:flutter/material.dart';
import '../API/company.dart';
import '../sharedPreferences/prefsAuth.dart';

class Company {
  int? id;
  final String name;
  final String address;
  final String phone1;
  final String? phone2; // Nullable, since it's not required
  final String? sign; // Nullable, since it's optional
  final String session;
  final String sessionStart;
  final int priceGreenOlive;
  final int priceTayebOlive;
  final int priceDroOlive;

  Company({
    this.id,
    required this.name,
    required this.address,
    required this.phone1,
    this.phone2 = '', // Optional
    this.sign = '', // Optional
    required this.session,
    required this.sessionStart,
    this.priceGreenOlive = 0,
    this.priceTayebOlive = 0,
    this.priceDroOlive = 0,
  });

  // Factory constructor to create a Company from a JSON map
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      sign: json['sign'],
      session: json['session'],
      sessionStart: json['session_start'],
      priceGreenOlive: json['price_green_olive'],
      priceTayebOlive: json['price_tayeb_olive'],
      priceDroOlive: json['price_dro_olive'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone1': phone1,
      'phone2': phone2,
      'sign': sign,
      'session': session,
      'session_start': sessionStart,
      'price_green_olive': priceGreenOlive,
      'price_tayeb_olive': priceTayebOlive,
      'price_dro_olive': priceDroOlive,
    };
  }
}

class CompanyProvider with ChangeNotifier {
  Company? company;
  String? message;
  bool _isLoading = true;
  bool? error;

  bool get isLoading => _isLoading;



  Future<void> initializeProducts() async {
    _isLoading = true;
    
    final String? token = await getToken();
    final ress = await getCompany(token);
    company = ress['company'];
    message = ress['message'];
    error = ress['error'];
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNewCompany(Company com) async {
    company = com;
    notifyListeners();
  }

  Future<void> removeCompany() async {
    company = null;
    _isLoading = true;
    notifyListeners();
  }
}
