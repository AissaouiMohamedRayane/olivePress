import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Customer.dart';

//mouaadh
// const String url = 'http://192.168.95.245:8000';

//moi
const String url = 'http://192.168.106.183:8000';

Future<int?> AddCustomer(String? token, Customer customer) async {
  if (token == null) {
    return null; // Return null if the token is not provided
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
      final data = jsonDecode(response.body);
      print('rayane0');
      print(data); // Decode the JSON response
      final newCustomerId =
          data['id']; // Parse the response body to get the created company's ID
      // Assuming the ID is returned as 'id'
      return newCustomerId; // Return the created company's ID
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

Future<bool> UpdateCustomer(
    String? token, int customerId, Customer customer) async {
  if (token == null) {
    return false;
  }

  try {
    final response = await http.put(
      Uri.parse('$url/customer/update/$customerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Note the 'Token' prefix
      },
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 200) {
      // Check for '200 OK'
      // Customer update was successful
      print('Customer updated successfully');
      return true;
      // Parse the response body to get the updated customer's ID
    } else {
      // Log detailed error information
      print('Customer update failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return false; // Return null to indicate an error occurred
    }
  } catch (e) {
    print('An error occurred: $e');
    return false; // Return null to indicate an error occurred
  }
}

Future<bool> setCustomerPrinted(String? token, int customerId) async {
  if (token == null) {
    return false; // Return false if the token is not provided
  }

  try {
    final response = await http.patch(
      Uri.parse('$url/customer/set_printed/$customerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Note the 'Token' prefix
      },
      body: jsonEncode({
        'is_printed': true, // If required in the request body
      }),
    );

    if (response.statusCode == 200) {
      // Status 200 indicates success
      print('Customer printed status updated successfully');
      return true; // Return true to indicate success
    } else if (response.statusCode == 400) {
      print('Customer is already printed.');
      return false; // Return false if already printed
    } else {
      // Log detailed error information
      print(
          'Failed to update customer printed status with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return false; // Return false to indicate failure
    }
  } catch (e) {
    print('An error occurred: $e');
    return false; // Return false to indicate an error occurred
  }
}

Future<List<Customer>> searchCustomers(String? token, String query) async {
  try {
    final response = await http.get(
      Uri.parse('$url/customer/search?name=$query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Token $token', // Include this if your API requires authentication
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body into a list of Customer objects
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Customer> customers =
          data.map((json) => Customer.fromJson(json)).toList();
      print(customers[0].bags);
      return customers;
    } else {
      print('Failed to fetch customers: ${response.statusCode}');
      print('Error: ${response.body}');
      return [];
    }
  } catch (e) {
    print('An error occurred: $e');
    return [];
  }
}
