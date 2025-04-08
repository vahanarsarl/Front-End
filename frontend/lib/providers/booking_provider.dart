import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  Booking? _selectedBooking;
  bool _isLoading = false;
  String? _error;
  final BookingService _bookingService = BookingService();

  List<Booking> get bookings => _bookings;
  Booking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch user bookings
  Future<void> fetchUserBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookings = await _bookingService.getUserBookings();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create booking
  Future<Booking> createBooking(String productId, DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final booking = await _bookingService.createBooking(
        productId,
        startDate,
        endDate,
      );
      
      _bookings = [booking, ..._bookings];
      notifyListeners();
      return booking;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedBooking = await _bookingService.updateBookingStatus(bookingId, status);
      
      // Update the booking in the list
      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        _bookings[index] = updatedBooking;
      }
      
      if (_selectedBooking?.id == bookingId) {
        _selectedBooking = updatedBooking;
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}