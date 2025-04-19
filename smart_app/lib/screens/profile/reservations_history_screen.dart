import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/services.dart'; // Ajout pour SystemChrome

class ReservationsHistoryScreen extends StatefulWidget { // Changé en StatefulWidget
  const ReservationsHistoryScreen({super.key});

  @override
  _ReservationsHistoryScreenState createState() => _ReservationsHistoryScreenState();
}

class _ReservationsHistoryScreenState extends State<ReservationsHistoryScreen> { // Création de l'état
  @override
  void initState() {
    super.initState();
    // Définir la couleur de la barre de statut et de la barre de navigation
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF2A4D50), // Couleur de l'en-tête
      statusBarIconBrightness: Brightness.light, // Icônes blanches pour contraste
      systemNavigationBarColor: Colors.white, // Couleur de l'arrière-plan du Scaffold
      systemNavigationBarIconBrightness: Brightness.dark, // Icônes noires pour contraste
    ));
  }

  @override
  void dispose() {
    // Restaurer les paramètres par défaut lors de la sortie de l'écran
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false, // Désactiver SafeArea en haut
        bottom: false, // Désactiver SafeArea en bas
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)
                  .add(EdgeInsets.only(top: MediaQuery.of(context).padding.top)), // Ajouter padding pour la barre de statut
              color: const Color(0xFF2A4D50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  Text(
                    'RESERVATIONS',
                    style: GoogleFonts.poppins(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                  Text(
                    'HISTORY',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Orders',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildOrderList(context, [
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Pick-up location',
                          'date': 'Mar 22, 2025',
                          'status': 'Confirmed'
                        },
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Drop-off location',
                          'date': 'Mar 24, 2025',
                          'status': 'Confirmed'
                        },
                      ]),
                      SizedBox(height: 16.h),
                      Text(
                        'Past Orders',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildOrderList(context, [
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Pick-up location',
                          'date': 'Jan 15, 2025',
                          'status': 'Completed'
                        },
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Drop-off location',
                          'date': 'Jan 17, 2025',
                          'status': 'Completed'
                        },
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Pick-up location',
                          'date': 'Dec 10, 2024',
                          'status': 'Completed'
                        },
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Drop-off location',
                          'date': 'Dec 12, 2024',
                          'status': 'Completed'
                        },
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Pick-up location',
                          'date': 'Nov 5, 2024',
                          'status': 'Completed'
                        },
                        {
                          'location': 'Mohamed V Intl Airport, casab...',
                          'type': 'Drop-off location',
                          'date': 'Nov 7, 2024',
                          'status': 'Completed'
                        },
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildOrderList(BuildContext context, List<Map<String, String>> orders) {
    return Column(
      children: orders.map((order) {
        final isPickUp = order['type'] == 'Pick-up location';
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Image.asset(
                  isPickUp ? 'assets/icons/anloc.png' : 'assets/icons/neloc.png',
                  width: 30.w,
                  height: 30.h,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['location'] ?? 'Location inconnue',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        order['type'] ?? 'Type inconnu',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Date: ${order['date'] ?? 'Unknown'}',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Status: ${order['status'] ?? 'Unknown'}',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: order['status'] == 'Confirmed' ? Colors.green : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}