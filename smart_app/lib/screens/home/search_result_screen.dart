import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_app/constants.dart';
import 'package:smart_app/widgets/bottom_nav_bar.dart';
import 'filter_screen.dart';
import 'product_page_screen.dart';
import 'package:flutter/services.dart'; // Ajout pour SystemChrome

class Vehicle {
  final String category;
  final String name;
  final String imageUrl;
  final int doors;
  final int passengers;
  final int luggage;
  final String transmission;
  final String pricePerDay;
  final String estimatedTotal;
  final List<String> features;
  final String minDriverAge;

  Vehicle({
    required this.category,
    required this.name,
    required this.imageUrl,
    required this.doors,
    required this.passengers,
    required this.luggage,
    required this.transmission,
    required this.pricePerDay,
    required this.estimatedTotal,
    required this.features,
    required this.minDriverAge,
  });
}

class SearchResultScreen extends StatefulWidget {
  final String pickupLocation;
  final String pickupDate;
  final String dropoffDate;

  const SearchResultScreen({
    super.key,
    required this.pickupLocation,
    required this.pickupDate,
    required this.dropoffDate,
  });

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> with SingleTickerProviderStateMixin {
  List<Vehicle> allVehicles = [
    Vehicle(
      category: 'SUV',
      name: 'Toyota RAV4',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 3,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1800/day',
      estimatedTotal: 'MAD 3600 est. total',
      features: ['Automatic transmission', 'Air conditioning', 'GPS', 'Bluetooth'],
      minDriverAge: '23',
    ),
    Vehicle(
      category: 'Hatchback',
      name: 'Volkswagen Golf',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 2,
      transmission: 'Manual',
      pricePerDay: 'MAD 1200/day',
      estimatedTotal: 'MAD 2400 est. total',
      features: ['Manual transmission', 'Air conditioning', 'Bluetooth'],
      minDriverAge: '21',
    ),
    Vehicle(
      category: 'Crossover',
      name: 'Nissan Rogue',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 3,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1600/day',
      estimatedTotal: 'MAD 3200 est. total',
      features: ['Automatic transmission', 'GPS', 'Sunroof'],
      minDriverAge: '24',
    ),
    Vehicle(
      category: 'Sedan',
      name: 'Honda Accord',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 2,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1400/day',
      estimatedTotal: 'MAD 2800 est. total',
      features: ['Automatic transmission', 'Air conditioning', 'Heated seats'],
      minDriverAge: '22',
    ),
    Vehicle(
      category: 'Coupe',
      name: 'BMW 2 Series',
      imageUrl: 'assets/images/touareg.png',
      doors: 2,
      passengers: 4,
      luggage: 1,
      transmission: 'Manual',
      pricePerDay: 'MAD 2000/day',
      estimatedTotal: 'MAD 4000 est. total',
      features: ['Manual transmission', 'Sunroof', 'Bluetooth'],
      minDriverAge: '25+',
    ),
    Vehicle(
      category: 'Minivan',
      name: 'Chrysler Pacifica',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 7,
      luggage: 4,
      transmission: 'Automatic',
      pricePerDay: 'MAD 2200/day',
      estimatedTotal: 'MAD 4400 est. total',
      features: ['Automatic transmission', 'GPS', 'Heated seats'],
      minDriverAge: '24',
    ),
    Vehicle(
      category: 'Pickup',
      name: 'Ford F-150',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 3,
      transmission: 'Automatic',
      pricePerDay: 'MAD 2500/day',
      estimatedTotal: 'MAD 5000 est. total',
      features: ['Automatic transmission', 'Air conditioning', 'Bluetooth'],
      minDriverAge: '25+',
    ),
    Vehicle(
      category: 'Luxury SUV',
      name: 'Audi Q5',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 3,
      transmission: 'Automatic',
      pricePerDay: 'MAD 2500/day',
      estimatedTotal: 'MAD 5000 est. total',
      features: ['Automatic transmission', 'GPS', 'Sunroof', 'Heated seats'],
      minDriverAge: '25+',
    ),
    Vehicle(
      category: 'Compact',
      name: 'Renault Clio',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 2,
      transmission: 'Manual',
      pricePerDay: 'MAD 1050/day',
      estimatedTotal: 'MAD 2100 est. total',
      features: ['Manual transmission', 'Bluetooth'],
      minDriverAge: '21',
    ),
    Vehicle(
      category: 'Electric',
      name: 'Tesla Model 3',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 2,
      transmission: 'Automatic',
      pricePerDay: 'MAD 2800/day',
      estimatedTotal: 'MAD 5600 est. total',
      features: ['Automatic transmission', 'GPS', 'Bluetooth'],
      minDriverAge: '25+',
    ),
  ];

  List<Vehicle> filteredVehicles = [];
  String selectedSortBy = 'Featured';
  String selectedVehicleType = 'SUV';
  String selectedFeature = 'Automatic transmission';
  int selectedSeats = 4;
  String selectedDriverAge = '24';
  bool showSortOptions = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    filteredVehicles = List.from(allVehicles);
    applyFilters();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.2), end: const Offset(0, 0)).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Définir la couleur de la barre de statut et de la barre de navigation
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF004852), // Couleur de l'en-tête
      statusBarIconBrightness: Brightness.light, // Icônes blanches pour contraste
      systemNavigationBarColor: AppConstants.backgroundColor, // Couleur de l'arrière-plan du Scaffold
      systemNavigationBarIconBrightness: Brightness.dark, // Icônes noires pour contraste
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();

    // Restaurer les paramètres par défaut lors de la sortie de l'écran
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  int calculateDuration(String pickupDate, String dropoffDate) {
    try {
      final DateFormat formatter = DateFormat('MMM dd');
      final DateTime pickup = formatter.parse('$pickupDate ${DateTime.now().year}');
      final DateTime dropoff = formatter.parse('$dropoffDate ${DateTime.now().year}');
      return dropoff.difference(pickup).inDays;
    } catch (e) {
      return 2;
    }
  }

  void applyFilters() {
    setState(() {
      filteredVehicles = allVehicles.where((vehicle) {
        if (selectedVehicleType.isNotEmpty && vehicle.category != selectedVehicleType) {
          return false;
        }
        if (selectedFeature.isNotEmpty && !vehicle.features.contains(selectedFeature)) {
          return false;
        }
        if (vehicle.passengers < selectedSeats) {
          return false;
        }
        if (selectedDriverAge != '25+') {
          int selectedAge = int.parse(selectedDriverAge);
          if (vehicle.minDriverAge == '25+') {
            return false;
          }
          int vehicleMinAge = int.parse(vehicle.minDriverAge);
          if (vehicleMinAge > selectedAge) {
            return false;
          }
        }
        return true;
      }).toList();

      if (selectedSortBy == 'Lowest price') {
        filteredVehicles.sort((a, b) {
          double priceA = double.parse(a.pricePerDay.replaceAll('MAD ', '').replaceAll('/day', ''));
          double priceB = double.parse(b.pricePerDay.replaceAll('MAD ', '').replaceAll('/day', ''));
          return priceA.compareTo(priceB);
        });
      } else if (selectedSortBy == 'Highest price') {
        filteredVehicles.sort((a, b) {
          double priceA = double.parse(a.pricePerDay.replaceAll('MAD ', '').replaceAll('/day', ''));
          double priceB = double.parse(b.pricePerDay.replaceAll('MAD ', '').replaceAll('/day', ''));
          return priceB.compareTo(priceA);
        });
      } else if (selectedSortBy == 'A to Z') {
        filteredVehicles.sort((a, b) => a.name.compareTo(b.name));
      } else if (selectedSortBy == 'Z to A') {
        filteredVehicles.sort((a, b) => b.name.compareTo(a.name));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int durationDays = calculateDuration(widget.pickupDate, widget.dropoffDate);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        top: false, // Désactiver SafeArea en haut
        bottom: false, // Désactiver SafeArea en bas
        child: Column(
          children: [
            _buildHeader(durationDays),
            _buildMainContent(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildHeader(int durationDays) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h).add(EdgeInsets.only(top: MediaQuery.of(context).padding.top)), // Ajouter padding pour la barre de statut
      decoration: const BoxDecoration(
        color: Color(0xFF004852),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            'SELECT YOUR VEHICLE',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32.sp,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pickupLocation,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Tue ${widget.pickupDate} – Thu ${widget.dropoffDate}',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '|  ',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Days ',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '$durationDays',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterScreen(
                          initialSortBy: selectedSortBy,
                          initialVehicleType: selectedVehicleType,
                          initialFeature: selectedFeature,
                          initialSeats: selectedSeats.toString(),
                          initialDriverAge: selectedDriverAge,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        selectedSortBy = result['sortBy'] ?? selectedSortBy;
                        selectedVehicleType = result['vehicleType'] ?? selectedVehicleType;
                        selectedFeature = result['feature'] ?? selectedFeature;
                        selectedSeats = int.parse(result['seats'] ?? selectedSeats.toString());
                        selectedDriverAge = result['driverAge'] ?? selectedDriverAge;
                      });
                      applyFilters();
                    }
                  },
                  icon: Icon(Icons.filter_list, size: 18.w),
                  label: Text(
                    'Filter & Sort',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (showSortOptions) {
                        showSortOptions = false;
                        _animationController.reverse();
                      } else {
                        selectedFeature = 'Automatic transmission';
                        showSortOptions = true;
                        _animationController.forward();
                      }
                    });
                    applyFilters();
                  },
                  icon: Icon(Icons.settings, size: 18.w),
                  label: Text(
                    'Automatic transmission',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedFeature == 'Automatic transmission'
                        ? Colors.grey.shade300
                        : Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
              ],
            ),
            if (showSortOptions) ...[
              SizedBox(height: 8.h),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSortOption(
                          'Prix : Haut vers Bas',
                          'Highest price',
                          Icon(Icons.arrow_downward, color: Colors.blueAccent, size: 20.w),
                        ),
                        _buildDivider(),
                        _buildSortOption(
                          'Prix : Bas vers Haut',
                          'Lowest price',
                          Icon(Icons.arrow_upward, color: Colors.green, size: 20.w),
                        ),
                        _buildDivider(),
                        _buildSortOption(
                          'Nom : A vers Z',
                          'A to Z',
                          Icon(Icons.sort_by_alpha, color: Colors.purple, size: 20.w),
                        ),
                        _buildDivider(),
                        _buildSortOption(
                          'Nom : Z vers A',
                          'Z to A',
                          Icon(Icons.sort_by_alpha, color: Colors.orange, size: 20.w),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: filteredVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = filteredVehicles[index];
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPageScreen(
                              pickupLocation: widget.pickupLocation,
                              pickupDate: widget.pickupDate,
                              dropoffDate: widget.dropoffDate,
                              category: vehicle.category,
                              name: vehicle.name,
                              imageUrl: vehicle.imageUrl,
                              doors: vehicle.doors,
                              passengers: vehicle.passengers,
                              luggage: vehicle.luggage,
                              transmission: vehicle.transmission,
                              pricePerDay: vehicle.pricePerDay,
                              estimatedTotal: vehicle.estimatedTotal,
                            ),
                          ),
                        );
                      },
                      child: _buildVehicleCard(
                        category: vehicle.category,
                        name: vehicle.name,
                        imageUrl: vehicle.imageUrl,
                        doors: vehicle.doors,
                        passengers: vehicle.passengers,
                        luggage: vehicle.luggage,
                        transmission: vehicle.transmission,
                        pricePerDay: vehicle.pricePerDay,
                        estimatedTotal: vehicle.estimatedTotal,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom), // Ajouter padding pour la barre de navigation
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Divider(
        color: Colors.grey.shade300,
        thickness: 1.w,
        height: 1.h,
      ),
    );
  }

  Widget _buildSortOption(String displayText, String sortValue, Icon icon) {
    bool isSelected = selectedSortBy == sortValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSortBy = sortValue;
          showSortOptions = false;
          _animationController.reverse();
        });
        applyFilters();
      },
      onDoubleTap: () {
        if (isSelected) {
          setState(() {
            selectedSortBy = 'Featured';
            showSortOptions = false;
            _animationController.reverse();
          });
          applyFilters();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                SizedBox(width: 12.w),
                Text(
                  displayText,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.blue : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            if (isSelected)
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 20.w,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard({
    required String category,
    required String name,
    required String imageUrl,
    required int doors,
    required int passengers,
    required int luggage,
    required String transmission,
    required String pricePerDay,
    required String estimatedTotal,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Image.asset(
            imageUrl,
            width: 250.w,
            height: 150.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.directions_car, size: 120.w, color: Colors.black54);
            },
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/de2.png',
                width: 16.w,
                height: 16.h,
                color: Colors.black54,
              ),
              SizedBox(width: 4.w),
              Text(
                '$doors',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Image.asset(
                'assets/icons/de3.png',
                width: 16.w,
                height: 16.h,
                color: Colors.black54,
              ),
              SizedBox(width: 4.w),
              Text(
                '$passengers',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Image.asset(
                'assets/icons/de4.png',
                width: 16.w,
                height: 16.h,
                color: Colors.black54,
              ),
              SizedBox(width: 4.w),
              Text(
                '$luggage',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Image.asset(
                'assets/icons/de1.png',
                width: 16.w,
                height: 16.h,
                color: Colors.black54,
              ),
              SizedBox(width: 4.w),
              Text(
                transmission,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1.w,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Price',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pricePerDay,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    estimatedTotal,
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}