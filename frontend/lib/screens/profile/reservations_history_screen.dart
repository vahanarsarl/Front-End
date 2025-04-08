import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de FlutterScreenUtil
import 'package:google_fonts/google_fonts.dart'; // Ajout de GoogleFonts pour Poppins
import 'package:vahanar_front/widgets/bottom_nav_bar.dart';

class ReservationsHistoryScreen extends StatelessWidget {
  const ReservationsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec flèche de retour et titre
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                      // Titre "Active Orders"
                      Text(
                        'Active Orders',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Liste des commandes actives
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
                      // Titre "Past Orders"
                      Text(
                        'Past Orders',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Liste des commandes passées
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

  // Méthode pour construire la liste des commandes
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