import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Locations.dart';

//mouaadh
// const String url = 'http://192.168.95.245:8000';

//moi
const String url = 'http://192.168.70.200:8000';

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
      final List<dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));

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

Future<List<String>?> getZones(String? token, String state) async {
  if (token == null) {
    return null;
  }
  try {
    final response = await http.get(
      Uri.parse('$url/customer/list_zones/$state'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token'
      },
    );

    if (response.statusCode == 200) {
      // The login was successful
      final List<dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));

      // Save the token for future API requests (e.g., using shared_preferences)
      return responseData.map((state) => state['zone']!.toString()).toList();
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
