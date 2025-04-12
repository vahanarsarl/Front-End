import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vahanar_front/providers/auth_provider.dart';
import 'package:vahanar_front/widgets/bottom_nav_bar.dart';
import 'package:vahanar_front/screens/profile/edit_profile_screen.dart';
import 'package:vahanar_front/screens/profile/driver_license_camera_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Ajout pour SystemChrome

class ProfileScreen extends StatefulWidget { // Changé en StatefulWidget
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> { // Création de l'état
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
    final authProvider = Provider.of<AuthProvider>(context);
    final hasDriverLicense = authProvider.user?.hasDriverLicense ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false, // Désactiver SafeArea en haut
        bottom: false, // Désactiver SafeArea en bas
        child: authProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(context),
                  if (!hasDriverLicense) ...[
                    Container(
                      color: Colors.yellow,
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 24.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DriverLicenseCameraScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Finish setting up your profile by adding your driver license to book a car.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                      child: Column(
                        children: [
                          _buildOptionTile(
                            icon: Icons.help_outline,
                            title: 'Help center',
                            onTap: () {
                              Navigator.pushNamed(context, '/help_center');
                            },
                          ),
                          SizedBox(height: 20.h),
                          _buildOptionTile(
                            icon: Icons.calendar_today,
                            title: 'My reservations',
                            onTap: () {
                              Navigator.pushNamed(context, '/my_reservations');
                            },
                          ),
                          SizedBox(height: 20.h),
                          _buildOptionTile(
                            icon: Icons.lock,
                            title: 'General conditions',
                            onTap: () {
                              Navigator.pushNamed(context, '/general_conditions');
                            },
                          ),
                          SizedBox(height: 20.h),
                          _buildOptionTile(
                            icon: Icons.logout,
                            title: 'Log out',
                            onTap: () async {
                              await Provider.of<AuthProvider>(context, listen: false).logout();
                              Navigator.pushReplacementNamed(context, '/sign_in');
                            },
                          ),
                          const Spacer(),
                          const ProfileFooter(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final fullName = user != null ? '${user.firstName} ${user.lastName}' : 'John Doe';
    final profileImageUrl = user?.profileImageUrl;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h)
          .add(EdgeInsets.only(top: MediaQuery.of(context).padding.top)), // Ajouter padding pour la barre de statut
      color: const Color(0xFF2A4D50),
      child: Column(
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
              Text(
                'Profile',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 48.w),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: profileImageUrl != null && profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/images/profile_picture.png') as ImageProvider,
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => const AssetImage('assets/images/profile_picture.png'),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fullName,
                      style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    //SizedBox(height: 4.h),
                    //GestureDetector(
                     // onTap: () {
                       // Navigator.push(
                         // context,
                         // MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                       // );
                      //},
                     // child: Row(
                        //children: [
                          //Icon(
                            //Icons.edit,
                            //color: Colors.grey,
                            //size: 18.w,
                          //),
                          //SizedBox(width: 4.w),
                          //Text(
                            //'Edit Profile',
                           // style: GoogleFonts.poppins(
                             // fontSize: 18.sp,
                             // color: Colors.grey,
                            //),
                          //),
                        //],
                      //),
                    //),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return AnimatedOptionTile(
      icon: icon,
      title: title,
      onTap: onTap,
    );
  }
}

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 4.h,
          color: const Color(0xFF2A4D50),
        ),
        SizedBox(height: 16.h),
        Text(
          'Get to know more about US :',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: const Color(0xFF2A4D50),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/icons/facebook.png',
                width: 30.w,
                height: 30.h,
              ),
              onPressed: () {
                _launchURL('https://web.facebook.com/people/Vahanar/61574664671787/');
              },
            ),
            SizedBox(width: 16.w),
            IconButton(
              icon: Image.asset(
                'assets/icons/insta.png',
                width: 30.w,
                height: 30.h,
              ),
              onPressed: () {
                _launchURL('https://www.instagram.com/vahanar_/');
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

class AnimatedOptionTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AnimatedOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  _AnimatedOptionTileState createState() => _AnimatedOptionTileState();
}

class _AnimatedOptionTileState extends State<AnimatedOptionTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isTapped = true;
    });
    _controller.forward().then((_) {
      widget.onTap();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isTapped = false;
          });
          _controller.reverse();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: _isTapped ? Colors.grey.shade200 : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 30.w,
                color: Colors.black,
              ),
              SizedBox(width: 16.w),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}