import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de l'importation de flutter_screenutil
import 'package:provider/provider.dart';

// Theme import
import 'theme.dart';

// Provider imports
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/booking_provider.dart';

// Router import
import 'router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: ScreenUtilInit( // Ajout de ScreenUtilInit
        designSize: const Size(375, 812), // Taille de conception de référence (iPhone 14)
        minTextAdapt: true, // Permet au texte de s'adapter automatiquement
        splitScreenMode: true, // Supporte les écrans partagés (par exemple, tablettes)
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'VAHANAR',
            theme: AppTheme.lightTheme,
            initialRoute: '/', // Route initiale
            onGenerateRoute: AppRouter.generateRoute, // Utilise le router
          );
        },
      ),
    );
  }
}