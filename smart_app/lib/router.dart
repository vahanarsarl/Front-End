import 'package:flutter/material.dart';
import 'package:smart_app/screens/auth/splash_screen.dart';
import 'package:smart_app/screens/auth/greeting_screen.dart';
import 'package:smart_app/screens/auth/sign_up/sign_up_step1.dart';
import 'package:smart_app/screens/auth/sign_up/sign_up_step2.dart';
import 'package:smart_app/screens/auth/sign_up/create_password.dart';
import 'package:smart_app/screens/auth/sign_up/finish_sign_up_screen.dart';
import 'package:smart_app/screens/auth/sign_in_screen.dart';
import 'package:smart_app/screens/auth/forgot_password/forgot_password.dart';
import 'package:smart_app/screens/auth/forgot_password/pass_email.dart';
import 'package:smart_app/screens/home/home_screen.dart';
import 'package:smart_app/screens/home/search_screen.dart';
import 'package:smart_app/screens/home/search_result_screen.dart';
import 'package:smart_app/screens/home/filter_screen.dart';
import 'package:smart_app/screens/profile/profile_screen.dart';
import 'package:smart_app/screens/help_center/help_center_screen.dart';
import 'package:smart_app/screens/profile/reservations_history_screen.dart';

// Placeholders pour les pages manquantes (comme dans main.dart)
class DrivingLicenceScreen extends StatelessWidget {
  const DrivingLicenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Driving Licence Screen')),
    );
  }
}

class GeneralConditionsScreen extends StatelessWidget {
  const GeneralConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('General Conditions Screen')),
    );
  }
}

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/splash_screen':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/greeting':
        return MaterialPageRoute(builder: (_) => const GreetingScreen());
      case '/sign_up/step1':
        return MaterialPageRoute(builder: (_) => const SignUpStep1Screen());
      case '/sign_up/step2':
        return MaterialPageRoute(builder: (_) => const VerifyPhoneScreen());
      case '/sign_up/create_password':
        return MaterialPageRoute(builder: (_) => const CreatePasswordScreen());
      case '/sign_up/finish':
        return MaterialPageRoute(builder: (_) => const FinishSignUpScreen());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/forgot_password/pass_email':
        return MaterialPageRoute(builder: (_) => const EmailSentScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/search/result':
        // Récupérer les arguments passés à la route
        final args = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          builder: (_) => SearchResultScreen(
            pickupLocation: args?['pickupLocation'] ?? 'Default Location',
            pickupDate: args?['pickupDate'] ?? 'Mar 22',
            dropoffDate: args?['dropoffDate'] ?? 'Mar 24',
          ),
        );
      case '/search/filter':
        final args = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          builder: (_) => FilterScreen(
            initialSortBy: args?['sortBy'] ?? 'Featured',
            initialVehicleType: args?['vehicleType'] ?? 'SUV',
            initialFeature: args?['feature'] ?? 'Automatic transmission',
            initialSeats: args?['seats'] ?? '4',
            initialDriverAge: args?['driverAge'] ?? '24',
          ),
        );
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/driving_licence':
        return MaterialPageRoute(builder: (_) => const DrivingLicenceScreen());
      case '/help_center':
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case '/my_reservations':
        return MaterialPageRoute(builder: (_) => const ReservationsHistoryScreen());
      case '/general_conditions':
        return MaterialPageRoute(builder: (_) => const GeneralConditionsScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('ERROR: Route not found!')),
      );
    });
  }
}