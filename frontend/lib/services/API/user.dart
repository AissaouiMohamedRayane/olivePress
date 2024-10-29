import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';

//mouaadh
const String url = 'http://192.168.95.245:8000';

//moi
// const String url = 'http://192.168.106.183:8000';

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
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));

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
      final List<dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));

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

Future<bool> setUserOliveType(String? token, int userId, int oliveType) async {
  if (token == null) {
    print("No token provided");
    return false; // Return false if the token is null
  }

  try {
    final response = await http.put(
      Uri.parse(
          '$url/auth/change_olive_type/$userId'), // Replace with your API URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token', // Use the provided token
      },
      body: jsonEncode({
        'olive_type': oliveType, // The new olive_type value to be set
      }),
    );

    if (response.statusCode == 200) {
      // Olive type updated successfully
      print('Olive type updated successfully');
      return true;
    } else {
      // Handle error response
      print('Error updating olive type: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}

Future<bool> modifyUser(String? token, User? user,
    {String? name, String? password}) async {
  if (token == null || (name == null && password == null && user == null)) {
    print('Token or fields to modify are missing');
    return false;
  }

  try {
    final response = await http.put(
      Uri.parse(
          '$url/auth/edit_user_by_id/${user!.id}'), // Assuming the endpoint is 'modify_user'
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token'
      },
      body: json.encode({
        if (name != null) 'username': name, // Add name to body if it's provided
        if (password != null)
          'password': password, // Add password to body if provided
      }),
    );

    if (response.statusCode == 200) {
      // The modification was successful
      print('User modified successfully');
      return true;
    } else {
      // Modification failed
      print('Modifying user failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
      return false;
    }
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}
