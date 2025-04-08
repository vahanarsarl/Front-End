import 'package:intl/intl.dart';

class Helpers {
  /// Validates if the given email is valid
  static bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  /// Validates if the given password meets complexity requirements
  static bool isValidPassword(String password) {
    // Password must be at least 8 characters long, contain one uppercase letter,
    // one lowercase letter, one digit, and one special character
    final RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }

  /// Formats a DateTime object into a human-readable string like "January 1, 2024"
  static String formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  /// Calculates the difference in days between two DateTime objects
  static int daysBetween(DateTime from, DateTime to) {
    return (to.difference(from).inDays).round();
  }

  /// Capitalizes the first letter of each word in a string
  static String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.split(' ').map((word) {
      if (word.isEmpty) {
        return '';
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}