import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vahanar_front/config/api_config.dart';
import '../models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final storage = const FlutterSecureStorage();
  final Duration _timeout = const Duration(seconds: 10);
  // Mode mock pour simuler les appels au serveur
  final bool useMock = true; // Mettre à false une fois que le backend est prêt

  Future<http.Response> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Object? body,
  }) async {
    if (useMock) {
      // Simuler une réponse HTTP
      await Future.delayed(Duration(seconds: 1)); // Simuler un délai réseau
      if (method == 'POST' && endpoint == ApiConfig.register) {
        // Simuler une erreur "User already exists" pour certains emails
        if (body.toString().contains('existing@example.com')) {
          return http.Response(
            jsonEncode({'error': 'User already exists'}),
            400,
          );
        }
        return http.Response(
          jsonEncode({
            'token': 'mock_token',
            'user': {
              'id': 1, // Utiliser un int au lieu de 'mock_user_id'
              'email': (body as Map)['email'],
              'firstName': (body)['firstName'],
              'lastName': (body)['lastName'],
              'phoneNumber': (body)['phoneNumber'],
              'isRegistrationComplete': false, // Ajouter les paramètres requis
              'hasDriverLicense': false, // Ajouter les paramètres requis
            },
          }),
          201,
        );
      } else if (method == 'PATCH' && endpoint == '/users/me/password') {
        // Simuler une mise à jour réussie du mot de passe
        return http.Response(
          jsonEncode({'message': 'Password updated successfully'}),
          200,
        );
      } else if (method == 'GET' && endpoint == ApiConfig.userProfile) {
        return http.Response(
          jsonEncode({
            'id': 1, // Utiliser un int
            'email': 'mock@example.com',
            'firstName': 'Mock',
            'lastName': 'User',
            'phoneNumber': '1234567890',
            'isRegistrationComplete': false,
            'hasDriverLicense': false,
          }),
          200,
        );
      } else if (method == 'POST' && endpoint == '/users/me/profile-image') {
        return http.Response(
          jsonEncode({'message': 'Profile image uploaded successfully'}),
          200,
        );
      } else if (method == 'PATCH' && endpoint == '/users/me') {
        return http.Response(
          jsonEncode({
            'user': {
              'id': 1, // Utiliser un int
              'email': 'mock@example.com',
              'firstName': (body as Map)['firstName'] ?? 'Mock',
              'lastName': (body)['lastName'] ?? 'User',
              'phoneNumber': (body)['phoneNumber'] ?? '1234567890',
              'isRegistrationComplete': false,
              'hasDriverLicense': false,
            },
          }),
          200,
        );
      } else if (method == 'POST' && endpoint == '/users/me/driver-license') {
        return http.Response(
          jsonEncode({
            'user': {
              'id': 1, // Utiliser un int
              'email': 'mock@example.com',
              'firstName': 'Mock',
              'lastName': 'User',
              'phoneNumber': '1234567890',
              'isRegistrationComplete': false,
              'hasDriverLicense': true, // Simuler que la licence a été uploadée
            },
          }),
          200,
        );
      } else if (method == 'POST' && endpoint == ApiConfig.login) {
        return http.Response(
          jsonEncode({
            'token': 'mock_token',
            'user': {
              'id': 1, // Utiliser un int
              'email': (body as Map)['email'],
              'firstName': 'Mock',
              'lastName': 'User',
              'phoneNumber': '1234567890',
              'isRegistrationComplete': false,
              'hasDriverLicense': false,
            },
          }),
          200,
        );
      } else if (method == 'POST' && endpoint == ApiConfig.forgotPassword) {
        return http.Response(
          jsonEncode({'message': 'Reset email sent'}),
          200,
        );
      } else if (method == 'POST' && endpoint == ApiConfig.verifyPhone) {
        return http.Response(
          jsonEncode({
            'id': 1, // Utiliser un int
            'email': 'mock@example.com',
            'firstName': 'Mock',
            'lastName': 'User',
            'phoneNumber': '1234567890',
            'isRegistrationComplete': true, // Simuler que l'inscription est complète après vérification
            'hasDriverLicense': false,
          }),
          200,
        );
      }
      return http.Response(
        jsonEncode({'error': 'Not implemented in mock mode'}),
        400,
      );
    }

    final uri = Uri.parse(ApiConfig.baseUrl + endpoint);
    final defaultHeaders = {
      'Content-Type': 'application/json',
    };
    final token = await storage.read(key: 'auth_token');
    if (token != null) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    }
    final finalHeaders = {...defaultHeaders, ...?headers};

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          return await http.get(uri, headers: finalHeaders).timeout(_timeout);
        case 'POST':
          return await http
              .post(uri, headers: finalHeaders, body: jsonEncode(body))
              .timeout(_timeout);
        case 'PATCH':
          return await http
              .patch(uri, headers: finalHeaders, body: jsonEncode(body))
              .timeout(_timeout);
        default:
          throw AuthException('Unsupported HTTP method: $method');
      }
    } catch (e) {
      throw AuthException('Network error: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }

  Future<User?> getCurrentUser() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) return null;

    final response = await _makeRequest(
      method: 'GET',
      endpoint: ApiConfig.userProfile,
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw AuthException(
          jsonDecode(response.body)['error'] ?? 'Failed to load user profile');
    }
  }

  Future<User> register(
    String email, {
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    final response = await _makeRequest(
      method: 'POST',
      endpoint: ApiConfig.register,
      body: {
        'email': email,
        if (password != null) 'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      },
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'auth_token', value: token);
      return User.fromJson(data['user']);
    } else {
      throw AuthException(
          jsonDecode(response.body)['error'] ?? 'Failed to register');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) throw AuthException('No user logged in');

    final response = await _makeRequest(
      method: 'PATCH',
      endpoint: '/users/me/password',
      body: {
        'password': newPassword,
      },
    );

    if (response.statusCode != 200) {
      throw AuthException(
          jsonDecode(response.body)['error'] ?? 'Failed to update password');
    }
  }

  Future<void> uploadProfileImage(File image) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) throw AuthException('No user logged in');

    if (useMock) {
      await Future.delayed(Duration(seconds: 1));
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/users/me/profile-image'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send().timeout(_timeout);
    if (response.statusCode != 200) {
      throw AuthException('Failed to upload profile image');
    }
  }

  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    final response = await _makeRequest(
      method: 'PATCH',
      endpoint: '/users/me',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw AuthException(
          jsonDecode(response.body)['error'] ?? 'Failed to update profile');
    }
  }

  Future<User> uploadDriverLicense(File frontImage, File backImage) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) throw AuthException('No user logged in');

    if (useMock) {
      await Future.delayed(Duration(seconds: 1));
      return User(
        id: 1, // Utiliser un int
        email: 'mock@example.com',
        firstName: 'Mock',
        lastName: 'User',
        phoneNumber: '1234567890',
        isRegistrationComplete: false, // Ajouter les paramètres requis
        hasDriverLicense: true, // Simuler que la licence a été uploadée
      );
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/users/me/driver-license'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('front', frontImage.path));
    request.files.add(await http.MultipartFile.fromPath('back', backImage.path));

    final response = await request.send().timeout(_timeout);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(responseBody)['user']);
    } else {
      throw AuthException(
          jsonDecode(responseBody)['error'] ?? 'Failed to upload driver license');
    }
  }

  Future<User> login(String email, String password) async {
    final response = await _makeRequest(
      method: 'POST',
      endpoint: ApiConfig.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'auth_token', value: token);
      return User.fromJson(data['user']);
    } else {
      throw AuthException(
          jsonDecode(response.body)['error'] ?? 'Failed to login');
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await _makeRequest(
      method: 'POST',
      endpoint: ApiConfig.forgotPassword,
      body: {
        'email': email,
      },
    );

    if (response.statusCode != 200) {
      throw AuthException(
          jsonDecode(response.body)['error'] ?? 'Failed to send reset email');
    }
  }

  Future<User> verifyPhone(String code) async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) throw AuthException('No user logged in');

    final response = await _makeRequest(
      method: 'POST',
      endpoint: ApiConfig.verifyPhone,
      body: {
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw AuthException(
          jsonDecode(response.body)['error'] ?? 'Failed to verify phone');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }
}