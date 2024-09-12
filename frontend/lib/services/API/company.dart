import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Company.dart';

const String url = 'http://192.168.181.183:8000';

Future<Map<String, dynamic>> getCompany(String? token) async {
  if (token == null) {
    return {'company': null, 'message': 'you do not have the token'};
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
        return {'company': null, 'message': 'company does not exist'};
      }
      final Company company = Company.fromJson(responseData['company']);

      // Save the token for future API requests (e.g., using shared_preferences)
      return {'company': company, 'message': 'success'};
    } else if (response.statusCode == 401) {
      // The login failed
      print('fetching company failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return {'company': null, 'message': 'you are not an active user'};
    }
    return {'company': null, 'error': true, 'message': 'network errour'};
  } catch (e) {
    print('An error occurred: $e');
    return {'company': null};
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
