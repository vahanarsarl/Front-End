import 'package:intl/intl.dart';

class Formatters {
  /// Formats a price into a currency string with the given symbol
  static String formatCurrency(double price, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(price);
  }

  /// Formats a DateTime object into a specific date and time string
  static String formatDateTime(DateTime dateTime, {String pattern = 'yyyy-MM-dd HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Formats a number as a percentage with a specified number of decimal places
  static String formatPercentage(double value, {int decimalDigits = 0}) {
    final percentage = value * 100;
    return '${percentage.toStringAsFixed(decimalDigits)}%';
  }

  /// Formats a phone number to a standard format (e.g., (123) 456-7890)
  static String formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Check if the number is a valid 10-digit US number
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else {
      return phoneNumber; // Return the original number if it's not a 10-digit US number
    }
  }
}