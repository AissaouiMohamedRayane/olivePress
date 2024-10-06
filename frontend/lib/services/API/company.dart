import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Company.dart';

const String url = 'http://192.168.121.245:8000';
// const String url = 'http://192.168.197.183:8000';

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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
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

Future<int?> addCompany(String? token, Company company) async {
  if (token == null) {
    return null; // Return null if the token is not provided
  }

  print('rayaaaaan');
  print(company.priceGreenOlive);

  try {
    final response = await http.post(
      Uri.parse('$url/company/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Note the 'Token' prefix
      },
      body: jsonEncode(company.toJson()),
    );

    if (response.statusCode == 201) {
      // Check for '201 Created'
      // Company creation was successful

      // Parse the response body to get the created company's ID
      final responseData = jsonDecode(response.body);
      int? companyId =
          responseData['id']; // Assuming the ID is returned as 'id'
      return companyId; // Return the created company's ID
    } else {
      // Log detailed error information
      print('Company creation failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return null; // Return null to indicate failure
    }
  } catch (e) {
    print('An error occurred: $e');
    return null; // Return null to indicate an error occurred
  }
}

Future<int?> updateCompany(String? token, Company company) async {
  if (token == null) {
    return null;
  }

  try {
    final response = await http.put(
      Uri.parse('$url/company/${company.id}/'), // URL with company ID
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Note the 'Token' prefix
      },
      body:
          jsonEncode(company.toJson()), // Serialize the company object to JSON
    );

    if (response.statusCode == 200) {
      // Check for '200 OK' or '204 No Content'
      // Company update was successful
      return 1;
    } else {
      // Log detailed error information
      print('Company update failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return null;
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}
