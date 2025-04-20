import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de flutter_screenutil
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_app/constants.dart';
import 'package:smart_app/screens/home/search_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;

  final List<Map<String, dynamic>> _nearbyAgencies = [
    {'name': 'Agency Casablanca', 'latitude': 33.5731, 'longitude': -7.5898},
    {'name': 'Agency Rabat', 'latitude': 34.0209, 'longitude': -6.8416},
    {'name': 'Agency Marrakech', 'latitude': 31.6295, 'longitude': -7.9811},
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final location = Location();

    final hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await location.requestPermission();
    }

    final locationData = await location.getLocation();

    if (locationData.latitude != null && locationData.longitude != null) {
      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });

      _mapController.move(_userLocation!, 13.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];

    if (_userLocation != null) {
      markers.add(
        Marker(
          width: 40.w,
          height: 40.h,
          point: _userLocation!,
          builder: (ctx) => Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 40.w,
          ),
        ),
      );
    }

    for (var agency in _nearbyAgencies) {
      markers.add(
        Marker(
          width: 40.w,
          height: 40.h,
          point: LatLng(agency['latitude'], agency['longitude']),
          builder: (ctx) => Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40.w,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: const Color(0xFF004852),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _userLocation ?? LatLng(33.5731, -7.5898),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.smart_app',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        backgroundColor: AppConstants.primaryColor,
        child: Image.asset(
          'assets/icons/suiv.png',
          width: 24.w,
          height: 24.h,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24.w,
            );
          },
        ),
      ),
    );
  }
}