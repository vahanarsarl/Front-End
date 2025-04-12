import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout de GoogleFonts pour Poppins
import 'package:vahanar_front/animations/button_animations.dart';

class FilterScreen extends StatefulWidget {
  final String initialSortBy;
  final String initialVehicleType;
  final String initialFeature;
  final String initialSeats;
  final String initialDriverAge;

  const FilterScreen({
    super.key,
    required this.initialSortBy,
    required this.initialVehicleType,
    required this.initialFeature,
    required this.initialSeats,
    required this.initialDriverAge,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Variables pour stocker les sélections, initialisées avec les valeurs passées
  late String selectedSortBy;
  late String selectedVehicleType;
  late String selectedFeature;
  late String selectedSeats;
  late String selectedDriverAge;

  // Listes pour "Vehicle type" et "Features"
  final List<String> vehicleTypes = [
    'SUV',
    'Hatchback',
    'Crossover',
    'Sedan',
    'Coupe',
    'Minivan',
    'Pickup',
  ];

  final List<Map<String, dynamic>> features = [
    {'label': 'Automatic transmission', 'icon': Icons.directions_car},
    {'label': 'Manual transmission', 'icon': Icons.directions_car},
    {'label': 'Air conditioning', 'icon': Icons.ac_unit},
    {'label': 'GPS', 'icon': Icons.gps_fixed},
    {'label': 'Bluetooth', 'icon': Icons.bluetooth},
    {'label': 'Sunroof', 'icon': Icons.wb_sunny},
    {'label': 'Heated seats', 'icon': Icons.event_seat},
  ];

  @override
  void initState() {
    super.initState();
    // Initialiser les sélections avec les valeurs passées via le constructeur
    selectedSortBy = widget.initialSortBy;
    selectedVehicleType = widget.initialVehicleType;
    selectedFeature = widget.initialFeature;
    selectedSeats = widget.initialSeats;
    selectedDriverAge = widget.initialDriverAge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24.w,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Retour à SearchResultScreen
                    },
                  ),
                  Text(
                    'FILTRE',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(width: 48.w), // Espace pour équilibrer avec l'icône
                ],
              ),
            ),
            // Contenu principal
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section "Sort By"
                    Text(
                      'Sort By',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildFilterButton('Featured', selectedSortBy, (value) {
                          setState(() {
                            selectedSortBy = value;
                          });
                        }),
                        SizedBox(width: 8.w),
                        _buildFilterButton('Lowest ', selectedSortBy, (value) {
                          setState(() {
                            selectedSortBy = value;
                          });
                        }),
                        SizedBox(width: 7.w),
                        _buildFilterButton('Highest ', selectedSortBy, (value) {
                          setState(() {
                            selectedSortBy = value;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Section "Vehicle type" avec défilement horizontal
                    Text(
                      'Vehicle type',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            vehicleTypes.map((type) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: _buildFilterButton(
                                  type,
                                  selectedVehicleType,
                                  (value) {
                                    setState(() {
                                      selectedVehicleType = value;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Section "Features" avec défilement horizontal
                    Text(
                      'Features',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            features.map((feature) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: _buildFilterButton(
                                  feature['label'],
                                  selectedFeature,
                                  (value) {
                                    setState(() {
                                      selectedFeature = value;
                                    });
                                  },
                                  icon: feature['icon'],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Section "Minimum number of seats"
                    Text(
                      'Minimum number of seats',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildFilterButton('4', selectedSeats, (value) {
                          setState(() {
                            selectedSeats = value;
                          });
                        }),
                        SizedBox(width: 8.w),
                        _buildFilterButton('5', selectedSeats, (value) {
                          setState(() {
                            selectedSeats = value;
                          });
                        }),
                        SizedBox(width: 8.w),
                        _buildFilterButton('9', selectedSeats, (value) {
                          setState(() {
                            selectedSeats = value;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Section "Minimum Age of primary driver"
                    Text(
                      'Minimum Age of primary driver',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildFilterButton('21', selectedDriverAge, (value) {
                          setState(() {
                            selectedDriverAge = value;
                          });
                        }),
                        _buildFilterButton('22', selectedDriverAge, (value) {
                          setState(() {
                            selectedDriverAge = value;
                          });
                        }),
                        _buildFilterButton('23', selectedDriverAge, (value) {
                          setState(() {
                            selectedDriverAge = value;
                          });
                        }),
                        _buildFilterButton('24', selectedDriverAge, (value) {
                          setState(() {
                            selectedDriverAge = value;
                          });
                        }),
                        _buildFilterButton('25+', selectedDriverAge, (value) {
                          setState(() {
                            selectedDriverAge = value;
                          });
                        }),
                      ],
                    ),
                    // Ajout d'un espace en bas pour éviter que le contenu soit caché par le bouton fixe
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
            // Bouton "Show offers" en position fixe en bas
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Renvoyer les sélections à SearchResultScreen
                  Navigator.pop(context, {
                    'sortBy': selectedSortBy,
                    'vehicleType': selectedVehicleType,
                    'feature': selectedFeature,
                    'seats': selectedSeats,
                    'driverAge': selectedDriverAge,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004852),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Show offers',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    String selectedValue,
    Function(String) onTap, {
    IconData? icon,
  }) {
    bool isSelected = label == selectedValue;
    return ButtonAnimation(
      isSelected: isSelected,
      onTap: () => onTap(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.w,
                color: isSelected ? Colors.white : Colors.black,
              ),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
