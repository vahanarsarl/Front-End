import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vahanar_front/config/api_config.dart';
import '../models/user_model.dart';

class UserService {
  final storage = const FlutterSecureStorage();

  // ✅ Fetch all users (new method)
  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/api/users"));

      if (response.statusCode == 200) {
        List<dynamic> userList = jsonDecode(response.body);
        return userList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch users: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error fetching users: $error");
    }
  }

  // ✅ Get current user's profile
  Future<User> getUserProfile() async {
    try {
      final token = await storage.read(key: 'auth_token');

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/users/me"),
        headers: { 'Authorization': 'Bearer $token' },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load profile: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error loading profile: $error");
    }
  }

  // ✅ Update user profile
  Future<User> updateUserProfile({String? firstName, String? lastName, String? phoneNumber}) async {
    try {
      final token = await storage.read(key: 'auth_token');

      final response = await http.patch(
        Uri.parse("${ApiConfig.baseUrl}/api/users/me"),
        headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer $token' },
        body: jsonEncode({
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to update profile: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error updating profile: $error");
    }
  }
}