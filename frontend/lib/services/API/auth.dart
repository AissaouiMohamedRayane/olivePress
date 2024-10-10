import 'dart:convert';
import 'package:http/http.dart' as http;
import '../sharedPreferences/prefsAuth.dart';
import '../models/User.dart';

//mouaadh
const String url = 'http://192.168.110.245:8000';

//moi
// const String url = 'http://192.168.197.183:8000';

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

Future<void> logout(String? token) async {
  // Replace with your Django logout URL
  if (token == null) {
    return null;
  }
  try {
    final response = await http.post(
      Uri.parse('$url/auth/logout'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful logout
      print('Successfully logged out.');
      // Optionally, navigate to the login screen or clear user data
    } else {
      // Handle error
      print('Logout failed: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle network or other errors
    print('An error occurred: $e');
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
      Uri.parse('$url/auth/validate-token'),
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

Future<User?> getUser(String? token) async {
  if (token == null) {
    return null;
  }
  try {
    final response = await http.get(
      Uri.parse('$url/auth/get_user_data'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token'
      },
    );

    if (response.statusCode == 200) {
      // The login was successful
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Save the token for future API requests (e.g., using shared_preferences)
      return User.fromJson(responseData);
    } else {
      // The login failed
      print('fetching user failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return null;
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}

Future<List<User>?> getStaffUsers(String? token) async {
  if (token == null) {
    return null;
  }
  try {
    final response = await http.get(
      Uri.parse(
          '$url/auth/get_staff_users'), // Modify according to your API structure
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Ensure the token format is correct
      },
    );

    if (response.statusCode == 200) {
      // The request was successful, decode the response
      final List<dynamic> responseData = json.decode(response.body);

      // Map the list of JSON objects to a list of User objects
      return responseData.map((data) => User.fromJson(data)).toList();
    } else {
      // The request failed
      print('Fetching staff users failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return null;
    }
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}

Future<bool> deleteUser(String? token, int userId) async {
  if (token == null) {
    print("No token provided");
    return false; // Return false if the token is null
  }

  try {
    final response = await http.delete(
      Uri.parse(
          '$url/auth/delete_user_by_id/$userId'), // Replace with your API URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token' // Replace with your token if necessary
      },
    );

    if (response.statusCode == 204) {
      // User deleted successfully
      print('User deleted successfully');
      return true;
    } else {
      // Handle error response
      print('Error deleting user: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}

Future<bool> addUserToStaff(String? token, int userId) async {
  if (token == null) {
    print("No token provided");
    return false; // Return false if the token is null
  }

  try {
    final response = await http.put(
      Uri.parse(
          '$url/auth/add_user_to_staff/$userId'), // Replace with your API URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token' // Replace with your token if necessary
      },
    );

    if (response.statusCode == 200) {
      // User added to staff successfully
      print('User added to staff successfully');
      return true;
    } else {
      // Handle error response
      print('Error adding user to staff: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}
