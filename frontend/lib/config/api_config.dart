class ApiConfig {
  // Utiliser cette URL pour le développement local avec un émulateur Android
  static const String baseUrl = 'http://192.168.41.131:3000/api'; // Pour Android emulator
  // static const String baseUrl = 'http://localhost:3000/api'; // Pour iOS simulator
  // static const String baseUrl = 'https://your-backend-url.com/api'; // URL de production

  // API endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyPhone = '/auth/verify';
  static const String userProfile = '/users/me';
  static const String products = '/products';
  static const String bookings = '/bookings';
}