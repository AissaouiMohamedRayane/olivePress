import 'dart:convert';
import 'package:http/http.dart' as http;
import '../sharedPreferences/prefsAuth.dart';

const String url = 'http://192.168.181.183:8000';

Future<bool> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$url/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // The login was successful
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      await storeToken(token);

      // Save the token for future API requests (e.g., using shared_preferences)
      return true;
    } else {
      // The login failed
      print('Login failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}

Future<bool> register(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$url/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // The login was successful
      final Map<String, dynamic> responseData = json.decode(response.body);

      print('registerd! Token: $responseData');
      final String token = responseData['token'];
      await storeToken(token);

      // Save the token for future API requests (e.g., using shared_preferences)
      return true;
    } else {
      // The login failed
      print('register failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}

Future<bool> validateToken() async {
  final String? token = await getToken(); // Get the locally stored token

  if (token == null) {
    print('No token found');
    return false;
  }

  try {
    final response = await http.get(
      Uri.parse('$url/auth/validate-token/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true; // Token is valid
    } else {
      print('Token validation failed: ${response.statusCode}');
      await removeToken();
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}
