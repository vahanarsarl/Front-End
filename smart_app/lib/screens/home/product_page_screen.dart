import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_app/screens/home/conditions_popup.dart';
import 'package:flutter/services.dart'; // Pour SystemChrome
import 'package:screenshot/screenshot.dart'; // Pour capturer l'écran
import 'package:share_plus/share_plus.dart'; // Pour partager
import 'package:path_provider/path_provider.dart'; // Pour obtenir le chemin temporaire

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
  final String subtitle;
  final String description;

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
    required this.subtitle,
    required this.description,
  });
}

class ProductPageScreen extends StatefulWidget {
  final String pickupLocation;
  final String pickupDate;
  final String dropoffDate;
  final String category;
  final String name;
  final String imageUrl;
  final int doors;
  final int passengers;
  final int luggage;
  final String transmission;
  final String pricePerDay;
  final String estimatedTotal;

  const ProductPageScreen({
    super.key,
    required this.pickupLocation,
    required this.pickupDate,
    required this.dropoffDate,
    required this.category,
    required this.name,
    required this.imageUrl,
    required this.doors,
    required this.passengers,
    required this.luggage,
    required this.transmission,
    required this.pricePerDay,
    required this.estimatedTotal,
  });

  @override
  _ProductPageScreenState createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreen> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final ScreenshotController _screenshotController = ScreenshotController(); // Contrôleur pour la capture d'écran

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Définir la couleur de la barre de statut et de la barre de navigation
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF004852), // Couleur de l'en-tête
      statusBarIconBrightness: Brightness.light, // Icônes blanches pour contraste
      systemNavigationBarColor: Colors.grey.shade200, // Couleur de l'arrière-plan du Scaffold
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

  static final List<Vehicle> allVehicles = [
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
      subtitle: 'compact family SUV',
      description:
          'Le Toyota RAV4 est un SUV compact idéal pour les familles, offrant un espace généreux et un confort optimal. Il est équipé d’une transmission automatique fluide et d’un système de navigation GPS intégré. Parfait pour les trajets urbains ou les escapades en plein air, ce véhicule combine fiabilité et efficacité énergétique. Louez-le pour une expérience de conduite agréable et sécurisée.',
    ),
    Vehicle(
      category: 'SUV',
      name: 'Jeep Wrangler',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 4,
      luggage: 2,
      transmission: 'Manual',
      pricePerDay: 'MAD 1900/day',
      estimatedTotal: 'MAD 3800 est. total',
      features: ['Manual transmission', 'Sunroof'],
      minDriverAge: '23',
      subtitle: 'full-size adventure SUV',
      description:
          'Le Jeep Wrangler est conçu pour les amateurs d’aventure, avec une capacité tout-terrain exceptionnelle. Son toit ouvrant et sa transmission manuelle offrent une expérience de conduite unique. Ce SUV robuste est parfait pour explorer des terrains difficiles tout en restant confortable. Idéal pour les aventuriers en quête de liberté et de sensations fortes.',
    ),
    Vehicle(
      category: 'SUV',
      name: 'Ford Escape',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 3,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1700/day',
      estimatedTotal: 'MAD 3400 est. total',
      features: ['Automatic transmission', 'Air conditioning', 'Bluetooth'],
      minDriverAge: '22',
      subtitle: 'mid-size practical SUV',
      description:
          'Le Ford Escape est un SUV pratique et polyvalent, parfait pour les trajets quotidiens ou les voyages en famille. Il offre une transmission automatique et une climatisation efficace pour un confort optimal. Avec son design moderne et ses fonctionnalités Bluetooth, il répond aux besoins des conducteurs connectés. Un choix idéal pour une conduite sans stress.',
    ),
    Vehicle(
      category: 'SUV',
      name: 'Honda CR-V',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 3,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1850/day',
      estimatedTotal: 'MAD 3700 est. total',
      features: ['Automatic transmission', 'GPS', 'Heated seats'],
      minDriverAge: '24',
      subtitle: 'versatile family SUV',
      description:
          'Le Honda CR-V est un SUV familial polyvalent, connu pour son espace intérieur et son confort. Il est équipé d’une transmission automatique, d’un GPS et de sièges chauffants pour une expérience premium. Ce véhicule est parfait pour les longs trajets ou les aventures en famille. Louez-le pour une conduite fiable et agréable.',
    ),
    Vehicle(
      category: 'SUV',
      name: 'Subaru Forester',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 3,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1750/day',
      estimatedTotal: 'MAD 3500 est. total',
      features: ['Automatic transmission', 'Air conditioning', 'Sunroof'],
      minDriverAge: '23',
      subtitle: 'rugged outdoor SUV',
      description:
          'Le Subaru Forester est un SUV robuste conçu pour les amateurs de plein air, avec une excellente capacité tout-terrain. Il dispose d’une transmission automatique, d’une climatisation et d’un toit ouvrant pour plus de plaisir. Idéal pour les escapades en nature, ce véhicule offre une conduite stable et sécurisée. Parfait pour les aventures en plein air.',
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
      subtitle: 'compact city hatchback',
      description:
          'La Volkswagen Golf est une hatchback compacte parfaite pour la conduite en ville, avec une maniabilité exceptionnelle. Elle est équipée d’une transmission manuelle, d’une climatisation et de la connectivité Bluetooth. Ce véhicule est idéal pour les trajets urbains grâce à sa taille compacte et son efficacité. Louez-la pour une expérience de conduite pratique et économique.',
    ),
    Vehicle(
      category: 'Hatchback',
      name: 'Honda Civic Hatchback',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 2,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1300/day',
      estimatedTotal: 'MAD 2600 est. total',
      features: ['Automatic transmission', 'Air conditioning', 'Bluetooth'],
      minDriverAge: '22',
      subtitle: 'sporty urban hatchback',
      description:
          'La Honda Civic Hatchback combine un design sportif avec une praticité urbaine, idéale pour les jeunes conducteurs. Elle offre une transmission automatique, une climatisation et une connectivité Bluetooth pour un confort moderne. Ce véhicule est parfait pour ceux qui recherchent style et performance en ville. Une option idéale pour une conduite dynamique et connectée.',
    ),
    Vehicle(
      category: 'Hatchback',
      name: 'Ford Focus',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 2,
      transmission: 'Manual',
      pricePerDay: 'MAD 1100/day',
      estimatedTotal: 'MAD 2200 est. total',
      features: ['Manual transmission', 'Air conditioning'],
      minDriverAge: '21',
      subtitle: 'economical hatchback',
      description:
          'La Ford Focus est une hatchback économique, parfaite pour les petits budgets et les trajets en ville. Elle est équipée d’une transmission manuelle et d’une climatisation pour un confort de base. Ce véhicule offre une conduite simple et efficace, idéale pour les déplacements quotidiens. Louez-la pour une solution pratique et abordable.',
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
      subtitle: 'mid-size crossover SUV',
      description:
          'Le Nissan Rogue est un crossover de taille moyenne, parfait pour les familles ou les longs trajets. Il est équipé d’une transmission automatique, d’un GPS et d’un toit ouvrant pour une expérience de conduite agréable. Ce véhicule offre un bon équilibre entre confort et fonctionnalité, idéal pour les voyages. Louez-le pour une conduite polyvalente et confortable.',
    ),
    Vehicle(
      category: 'Crossover',
      name: 'Toyota C-HR',
      imageUrl: 'assets/images/touareg.png',
      doors: 4,
      passengers: 5,
      luggage: 2,
      transmission: 'Automatic',
      pricePerDay: 'MAD 1500/day',
      estimatedTotal: 'MAD 3000 est. total',
      features: ['Automatic transmission', 'Air conditioning', 'Bluetooth'],
      minDriverAge: '23',
      subtitle: 'stylish compact crossover',
      description:
          'Le Toyota C-HR est un crossover compact au design audacieux, parfait pour les conducteurs à la recherche de style. Il dispose d’une transmission automatique, d’une climatisation et de la connectivité Bluetooth pour une conduite moderne. Ce véhicule est idéal pour les trajets en ville ou les petites escapades. Une option élégante pour une expérience de conduite unique.',
    ),
  ];

  Vehicle? _findVehicle() {
    return allVehicles.firstWhere(
      (vehicle) => vehicle.name == widget.name && vehicle.category == widget.category,
      orElse: () => Vehicle(
        category: widget.category,
        name: widget.name,
        imageUrl: widget.imageUrl,
        doors: widget.doors,
        passengers: widget.passengers,
        luggage: widget.luggage,
        transmission: widget.transmission,
        pricePerDay: widget.pricePerDay,
        estimatedTotal: widget.estimatedTotal,
        features: [],
        minDriverAge: '21',
        subtitle: 'default vehicle',
        description: 'Aucune description disponible pour ce véhicule.',
      ),
    );
  }

  void _showConditionsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return const ConditionsPopup();
      },
    );
  }

  // Fonction pour capturer l'écran et partager
  Future<void> _captureAndShare() async {
    try {
      // Capturer l'écran
      final image = await _screenshotController.capture();
      if (image == null) return;

      // Obtenir le répertoire temporaire
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);

      // Enregistrer l'image temporairement
      await imageFile.writeAsBytes(image);

      // Partager l'image avec un message
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Check out this vehicle: ${widget.name} (${widget.category})!\nPrice: ${widget.pricePerDay}\nTotal: ${widget.estimatedTotal}',
      );

      // Nettoyer le fichier temporaire (optionnel)
      await imageFile.delete();
    } catch (e) {
      // Afficher une erreur si quelque chose échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSharePopup(BuildContext context) {
    _animationController.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SlideTransition(
          position: _slideAnimation,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.r,
                  offset: Offset(0, -5.h),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Container(
                  width: 40.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Share this vehicle',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    children: [
                      _buildShareOption(
                        iconPath: 'assets/icons/wath.png',
                        label: 'WhatsApp',
                        onTap: _captureAndShare, // Utilise la fonction de capture et partage
                      ),
                      _buildShareOption(
                        iconPath: 'assets/icons/facebook.png',
                        label: 'Facebook',
                        onTap: _captureAndShare,
                      ),
                      _buildShareOption(
                        iconPath: 'assets/icons/insta.png',
                        label: 'Instagram',
                        onTap: _captureAndShare,
                      ),
                      _buildShareOption(
                        iconPath: 'assets/icons/mes.png',
                        label: 'Messenger',
                        onTap: _captureAndShare,
                      ),
                      _buildShareOption(
                        iconPath: 'assets/icons/gmail.png',
                        label: 'Email',
                        onTap: _captureAndShare,
                      ),
                      _buildShareOption(
                        iconPath: 'assets/icons/sms.png',
                        label: 'SMS',
                        onTap: _captureAndShare,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      _animationController.reverse();
    });
  }

  Widget _buildShareOption({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300, width: 2.w),
            ),
            child: Image.asset(
              iconPath,
              width: 30.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = _findVehicle();

    return Screenshot(
      controller: _screenshotController, // Envelopper le Scaffold avec Screenshot
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          top: false, // Désactiver SafeArea en haut
          bottom: false, // Désactiver SafeArea en bas
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCarImage(),
                      _buildCarDetails(context, vehicle!.subtitle, vehicle.description),
                      SizedBox(height: MediaQuery.of(context).padding.bottom), // Ajouter padding pour la barre de navigation
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
          .add(EdgeInsets.only(top: MediaQuery.of(context).padding.top)), // Ajouter padding pour la barre de statut
      decoration: const BoxDecoration(
        color: Color(0xFF004852),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white, size: 24.w),
                onPressed: () {
                  _showSharePopup(context);
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REVIEW DETAILS',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildCarImage() {
    return Container(
      color: Colors.grey.shade300,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Image.asset(
        widget.imageUrl,
        width: 300.w,
        height: 200.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.directions_car, size: 120.w, color: Colors.black54);
        },
      ),
    );
  }

  Widget _buildCarDetails(BuildContext context, String subtitle, String description) {
    return Container(
      color: Colors.grey.shade200,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 20.h),
          _buildFeatureRow('assets/icons/de1.png', '${widget.transmission} Transmission', ''),
          _buildDivider(),
          _buildFeatureRow('assets/icons/de2.png', 'Seats', widget.passengers.toString()),
          _buildDivider(),
          _buildFeatureRow('assets/icons/de3.png', 'Doors', widget.doors.toString()),
          _buildDivider(),
          _buildFeatureRow('assets/icons/de4.png', 'Luggage', widget.luggage.toString()),
          _buildDivider(),
          SizedBox(height: 20.h),
          Text(
            'Car description',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          description.isEmpty
              ? Text(
                  'Aucune description disponible.',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isExpanded
                        ? Text(
                            description,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          )
                        : Text(
                            description,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                    if (!_isExpanded)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = true;
                          });
                        },
                        child: Text(
                          'Read more...',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    if (_isExpanded)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        child: Text(
                          'Read less',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                widget.estimatedTotal.replaceAll(' est. total', ''),
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showConditionsPopup(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004852),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Reserve',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String iconPath, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                iconPath,
                width: 20.w,
                height: 20.h,
                color: Colors.black,
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: const Color.fromARGB(255, 97, 97, 97),
                ),
              ),
            ],
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1.h,
      height: 1.h,
    );
  }
}