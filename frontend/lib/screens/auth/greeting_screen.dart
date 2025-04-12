import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vahanar_front/widgets/custom_button.dart';
import 'package:flutter/services.dart'; // Ajout pour SystemChrome

class GreetingScreen extends StatefulWidget { // Changé en StatefulWidget
  const GreetingScreen({super.key});

  @override
  _GreetingScreenState createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  @override
  void initState() {
    super.initState();
    // Définir la couleur de la barre de statut et de la barre de navigation
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Rendre la barre de statut transparente
      statusBarIconBrightness: Brightness.dark, // Icônes noires pour contraste avec l'image
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
    const buttonCornerRadius = 7.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 0.75.sh, // 75% de la hauteur de l'écran
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0.0)),
                  child: Image.asset(
                    'assets/images/vahanful.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              SafeArea(
                top: false, // Désactiver SafeArea en haut
                bottom: false, // Désactiver SafeArea en bas
                child: Column(
                  children: [
                    SizedBox(height: 0.05.sh + MediaQuery.of(context).padding.top), // Ajouter padding pour la barre de statut
                    Text(
                      'VAHANAR',
                      style: GoogleFonts.poppins(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF004852),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.25.sh),
                    Text(
                      'Earn points',
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        'Earn Vahanar points for every valuable dollar you spend and redeem for rewards and accessories',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomButton(
                            text: 'Create account',
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign_up/step1');
                            },
                            color: const Color(0xFF43919D),
                            borderRadius: BorderRadius.circular(buttonCornerRadius.r),
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                            height: 48.h,
                            isLoading: false,
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            text: 'Login',
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign_in');
                            },
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(buttonCornerRadius.r),
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                            height: 48.h,
                            isLoading: false,
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            text: 'Join as guest',
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            color: Colors.white, // Changer le background en blanc
                            borderSide: BorderSide(
                              color: const Color.from(alpha: 0.700, red: 0, green: 0.286, blue: 0.322), // Bordure bleue du projet
                              width: 2.w,
                            ),
                            borderRadius: BorderRadius.circular(buttonCornerRadius.r),
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: const Color(0xFF004852),
                            ),
                            height: 48.h,
                            isLoading: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h + MediaQuery.of(context).padding.bottom), // Ajouter padding pour la barre de navigation
                      child: Column(
                        children: [
                          Text(
                            'Want to get more information about us',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/about_us');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF004852),
                            ),
                            child: Text(
                              'Find more about us',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: const Color(0xFF004852),
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}