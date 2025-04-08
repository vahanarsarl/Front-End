import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de FlutterScreenUtil
import 'package:google_fonts/google_fonts.dart'; // Ajout de GoogleFonts pour Poppins

class EmailSentScreen extends StatelessWidget {
  const EmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/valide.png',
                height: 100.h, // Taille responsive
              ),
              SizedBox(height: 30.h),
              Text(
                "Successful",
                style: GoogleFonts.poppins(
                  fontSize: 28.sp, // Taille agrandie
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2A4D50), // Couleur verte foncée
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "We have sent you an email to help you change your password, please check your emails app.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp, // Taille agrandie
                  color: const Color(0xFF989898),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Did not receive an email?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp, // Taille agrandie
                  color: const Color(0xFF004852),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    backgroundColor: const Color(0xFF2A4D50), // Couleur comme dans ForgotPasswordScreen
                  ),
                  onPressed: () {
                    // Redirection vers la page d'accueil
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    "Let's go",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp, // Taille agrandie
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}