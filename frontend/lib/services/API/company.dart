import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Company.dart';

const String url = 'http://192.168.181.183:8000';

Future<Company?> getCompany(String? token) async {
  if (token == null) {
    return null;
  }
  try {
    final response = await http.get(
      Uri.parse('$url/company'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token'
      },
    );

    if (response.statusCode == 200) {
      // The login was successful
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['exists'] == false) {
        return null;
      }
      final Company company = Company.fromJson(responseData['company']);

      // Save the token for future API requests (e.g., using shared_preferences)
      return company;
    } else {
      // The login failed
      print('fetching company failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return null;
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}

Future<bool> addCompany(String? token, Company company) async {
  if (token == null) {
    return false;
  }
  print('rayaaaaan');
  print(company.priceGreenOlive);
  try {
    final response = await http.post(Uri.parse('$url/company/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token' // Note the 'Token' prefix
        },
        body: jsonEncode(company.toJson()));

    if (response.statusCode == 201) {
      // Check for '201 Created'
      // Company creation was successful
      return true;
    } else {
      // Log detailed error information
      print('Company creation failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}
