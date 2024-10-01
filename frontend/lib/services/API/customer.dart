import 'package:flutter/material.dart';
import 'package:frontend/services/models/Customer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//mouaadh
// const String url = 'http://192.168.121.245:8000';

//moi
const String url = 'http://192.168.19.183:8000';

Future<List<Wilaya>?> getStates(String? token) async {
  if (token == null) {
    return null;
  }
  try {
    final response = await http.get(
      Uri.parse('$url/customer/list_states'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token'
      },
    );

    if (response.statusCode == 200) {
      // The login was successful
      final List<dynamic> responseData = json.decode(response.body);

      // Save the token for future API requests (e.g., using shared_preferences)
      return responseData.map((state) => Wilaya.fromJson(state)).toList();
    } else if (response.statusCode == 401) {
      // The login failed
      print('fetching company failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return null;
    }
    return null;
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}

Future<bool> AddCustomer(String? token, Customer customer) async {
  if (token == null) {
    return false; // Return null if the token is not provided
  }

  try {
    final response = await http.post(
      Uri.parse('$url/customer/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Note the 'Token' prefix
      },
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 201) {
      // Check for '201 Created'
      // Company creation was successful

      // Parse the response body to get the created company's ID
      // Assuming the ID is returned as 'id'
      return true; // Return the created company's ID
    } else {
      // Log detailed error information
      print('Company creation failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return false; // Return false to indicate failure
    }
  } catch (e) {
    print('An error occurred: $e');
    return false; // Return false to indicate an error occurred
  }
}
