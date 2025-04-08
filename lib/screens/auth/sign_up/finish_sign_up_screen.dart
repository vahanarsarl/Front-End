import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de flutter_screenutil
import 'package:google_fonts/google_fonts.dart';
import 'package:vahanar_front/constants.dart';

class FinishSignUpScreen extends StatelessWidget {
  const FinishSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor, size: 24.w),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/valide.png',
                  height: 100.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 40.h),
                Text(
                  "Successful",
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.titleSize.sp ?? 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Your account has been created successfully.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstants.bodyTextSize.sp ?? 16.sp,
                    color: const Color(0xFF989898),
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      backgroundColor: AppConstants.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text(
                      "Let's go",
                      style: GoogleFonts.poppins(
                        fontSize: AppConstants.subtitleSize.sp ?? 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}