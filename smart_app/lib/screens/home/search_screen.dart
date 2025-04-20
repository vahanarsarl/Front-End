import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_app/constants.dart';
import 'package:smart_app/widgets/bottom_nav_bar.dart';
import 'package:smart_app/screens/home/search_result_screen.dart';
import 'package:smart_app/screens/home/map_screen.dart';
import 'package:smart_app/widgets/custom_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _pickupLocationController = TextEditingController(text: 'Mohamed V Intl Airport, casablanca');
  final TextEditingController _dropoffLocationController = TextEditingController(text: 'Mohamed V Intl Airport, casablanca');
  final TextEditingController _pickupDateController = TextEditingController(text: 'Mar 26 | 23:50 PM');
  final TextEditingController _dropoffDateController = TextEditingController(text: 'Mar 29 | 23:50 PM');
  final TextEditingController _discountCodeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedCountry = 'Morocco';
  DateTime? _pickupDateTime;
  DateTime? _dropoffDateTime;

  final List<String> _locations = [
    'Mohamed V Intl Airport, casablanca',
    'Paris Charles de Gaulle, FRA',
    'London Heathrow, UK',
    'New York JFK, USA',
    'Tokyo Narita, JPN',
    'Amsterdam Schiphol, NL',
    'Barcelona El Prat, ES',
    'Dubai Intl Airport, DXB',
    'Los Angeles Intl, LAX',
    'Sydney Kingsford Smith, AUS',
  ];

  List<String> _filteredPickupLocations = [];
  List<String> _filteredDropoffLocations = [];
  bool _showPickupDropdown = false;
  bool _showDropoffDropdown = false;

  final List<Map<String, String>> countries = [
    {'name': 'Morocco', 'flag': '🇲🇦'},
    {'name': 'France', 'flag': '🇫🇷'},
    {'name': 'USA', 'flag': '🇺🇸'},
    {'name': 'UK', 'flag': '🇬🇧'},
    {'name': 'Japan', 'flag': '🇯🇵'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredPickupLocations = _locations;
    _filteredDropoffLocations = _locations;

    _pickupLocationController.addListener(() => _filterLocations(_pickupLocationController.text, true));
    _dropoffLocationController.addListener(() => _filterLocations(_dropoffLocationController.text, false));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF004852),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _dropoffLocationController.dispose();
    _pickupDateController.dispose();
    _dropoffDateController.dispose();
    _discountCodeController.dispose();
    _ageController.dispose();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  void _filterLocations(String query, bool isPickup) {
    setState(() {
      final filtered = query.isEmpty
          ? _locations
          : _locations
              .where((location) => location.toLowerCase().startsWith(query.toLowerCase()))
              .toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()))
            ..addAll(_locations
                .where((location) =>
                    !location.toLowerCase().startsWith(query.toLowerCase()) &&
                    location.toLowerCase().contains(query.toLowerCase()))
                .toList()
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));

      if (isPickup) {
        _filteredPickupLocations = filtered;
      } else {
        _filteredDropoffLocations = filtered;
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isPickup) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isPickup) {
            _pickupDateTime = fullDateTime;
            _pickupDateController.text = _formatDateTime(fullDateTime);
          } else {
            if (_pickupDateTime != null && fullDateTime.isBefore(_pickupDateTime!)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Drop-off date cannot be before pick-up date',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            _dropoffDateTime = fullDateTime;
            _dropoffDateController.text = _formatDateTime(fullDateTime);
          }
        });
      }
    }
  }

  Future<void> _navigateToMapScreen(BuildContext context, bool isPickup) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        if (isPickup) {
          _pickupLocationController.text = result;
        } else {
          _dropoffLocationController.text = result;
        }
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    const monthAbbreviations = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = monthAbbreviations[dateTime.month - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$month $day | $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w).add(EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              color: const Color(0xFF004852),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'RESERVATION',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      _buildTextField(
                        icon: Icons.location_on,
                        controller: _pickupLocationController,
                        label: 'Pick-up Location',
                        isPickup: true,
                        onIconTap: () => _navigateToMapScreen(context, true),
                      ),
                      SizedBox(height: 16.h),
                      _buildTextField(
                        icon: Icons.location_on,
                        controller: _dropoffLocationController,
                        label: 'Drop-off Location',
                        isPickup: false,
                        onIconTap: () => _navigateToMapScreen(context, false),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(width: 2.w, color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                icon: Icons.calendar_today,
                                controller: _pickupDateController,
                                label: 'Pick-up Details',
                                onTap: () => _selectDateTime(context, true),
                              ),
                            ),
                            Container(
                              width: 1.w,
                              height: 40.h,
                              color: Colors.grey,
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                            ),
                            Expanded(
                              child: _buildDateField(
                                icon: Icons.calendar_today,
                                controller: _dropoffDateController,
                                label: 'Drop-off Details',
                                onTap: () => _selectDateTime(context, false),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 0.35.sw,
                            child: _buildAgeTextField(
                              label: 'Age',
                              controller: _ageController,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildCountryDropdownField(
                              label: 'Country of Residence',
                              value: _selectedCountry,
                              items: countries,
                              onChanged: (newValue) => setState(() => _selectedCountry = newValue ?? 'Morocco'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 239, 239, 239),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8.r,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/disc.png', width: 37.w, height: 32.h),
                            SizedBox(width: 10.w), // Ajout d'un espacement pour aligner avec les autres sections
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
                                children: [
                                  Text(
                                    'DISCOUNT CODES',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black, // Déjà en noir
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold, // Déjà en gras
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  TextField(
                                    controller: _discountCodeController,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal, // Valeur en light
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'YOURCODE',
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal, // Hint en light
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.start, // Alignement à gauche
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: 'FIND VEHICLES',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultScreen(
                                pickupLocation: _pickupLocationController.text,
                                pickupDate: _pickupDateController.text.split('|')[0].trim(),
                                dropoffDate: _dropoffDateController.text.split('|')[0].trim(),
                              ),
                            ),
                          );
                        },
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(7.r),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: const Color.fromARGB(239, 239, 239, 239),
                        ),
                        height: 40.h,
                        isLoading: false,
                      ),
                      SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
    required bool isPickup,
    required VoidCallback onIconTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 2.w, color: Colors.grey),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onIconTap,
                child: Icon(icon, color: Colors.grey[700], size: 30.w),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: Colors.black, // Titre en noir
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold, // Titre en gras
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: controller,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal, // Texte en light (déjà correct)
                      ),
                      decoration: const InputDecoration(border: InputBorder.none),
                      onTap: () {
                        setState(() {
                          if (isPickup) {
                            _showPickupDropdown = true;
                            _showDropoffDropdown = false;
                          } else {
                            _showDropoffDropdown = true;
                            _showPickupDropdown = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if ((isPickup && _showPickupDropdown) || (!isPickup && _showDropoffDropdown))
          Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(width: 2.w, color: Colors.grey),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: isPickup ? _filteredPickupLocations.length : _filteredDropoffLocations.length,
              itemBuilder: (context, index) {
                final location = isPickup ? _filteredPickupLocations[index] : _filteredDropoffLocations[index];
                return ListTile(
                  title: Text(
                    location,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal, // Texte en light (déjà correct)
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (isPickup) {
                        _pickupLocationController.text = location;
                        _showPickupDropdown = false;
                      } else {
                        _dropoffLocationController.text = location;
                        _showDropoffDropdown = false;
                      }
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDateField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[700], size: 24.w),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.black, // Titre en noir
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold, // Titre en gras
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  controller.text,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal, // Valeur en light
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 2.w, color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.black, // Titre en noir
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold, // Titre en gras
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal, // Valeur en light
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter age',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryDropdownField({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 2.w, color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.black, // Titre en noir
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold, // Titre en gras
                  ),
                ),
                SizedBox(height: 2.h),
                DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black54, size: 24.w),
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['name'],
                      child: Row(
                        children: [
                          Text(item['flag']!, style: TextStyle(fontSize: 18.sp)),
                          SizedBox(width: 10.w),
                          Text(
                            item['name']!,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal, // Valeur en light
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}