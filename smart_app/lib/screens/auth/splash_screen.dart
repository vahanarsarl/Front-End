import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smart_app/providers/auth_provider.dart';
import 'package:smart_app/screens/auth/greeting_screen.dart';
import 'package:flutter/services.dart'; // Ajout pour SystemChrome

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final loc.Location _location = loc.Location();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Définir la couleur de la barre de statut pour correspondre à l'arrière-plan
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF004852), // Couleur de la barre de statut
      statusBarIconBrightness: Brightness.light, // Icônes blanches pour contraste
    ));
    _initializeAndNavigate();
  }

  @override
  void dispose() {
    // Restaurer la barre de statut par défaut lors de la sortie de l'écran
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  Future<void> _initializeAndNavigate() async {
    _requestPermissions();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        print('Timer executed, navigating to GreetingScreen...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GreetingScreen()),
        );
      } else {
        print('Widget is not mounted, navigation skipped');
      }
    });
  }

  Future<void> _requestPermissions() async {
    try {
      await _requestLocationPermission();
      await _requestNotificationPermission();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      print('AuthProvider initialized, isLoggedIn: ${authProvider.isLoggedIn}');
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        if (mounted) {
          await _showPermissionDialog(
            title: 'Location Service Disabled',
            message: 'Please enable location services to use this app.',
            onRetry: _requestLocationPermission,
          );
        }
        return;
      }
    }

    PermissionStatus permissionStatus = await Permission.locationWhenInUse.status;
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        if (mounted) {
          await _showPermissionDialog(
            title: 'Location Permission Denied',
            message: 'Please allow location access to use this app.',
            onRetry: _requestLocationPermission,
          );
        }
        return;
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    var permissionStatus = await Permission.notification.status;
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      permissionStatus = await Permission.notification.request();
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        if (mounted) {
          await _showPermissionDialog(
            title: 'Notification Permission Denied',
            message: 'Please allow notifications to receive updates.',
            onRetry: _requestNotificationPermission,
          );
        }
        return;
      }
    }
  }

  Future<void> _showPermissionDialog({
    required String title,
    required String message,
    required Future<void> Function() onRetry,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 18.sp)),
        content: Text(message, style: TextStyle(fontSize: 14.sp)),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await onRetry();
            },
            child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004852),
      body: Center(
        child: Image.asset(
          'assets/images/vahanar1.png',
          width: 500.w,
          height: 500.h,
        ),
      ),
    );
  }
}