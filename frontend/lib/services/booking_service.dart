import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vahanar_front/config/api_config.dart';
import '../models/booking_model.dart';

class BookingService {
  final storage = const FlutterSecureStorage();

  // Create a booking
  Future<Booking> createBooking(String productId, DateTime startDate, DateTime endDate) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.post(
      Uri.parse(ApiConfig.baseUrl + ApiConfig.bookings),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'productId': productId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to create booking');
    }
  }

  // Get all bookings for the current user
  Future<List<Booking>> getUserBookings() async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse(ApiConfig.baseUrl + ApiConfig.bookings),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bookingsJson = jsonDecode(response.body);
      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to load bookings');
    }
  }

  // Update booking status
  Future<Booking> updateBookingStatus(String bookingId, String status) async {
    final token = await storage.read(key: 'auth_token');

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.bookings}/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to update booking');
    }
  }
}