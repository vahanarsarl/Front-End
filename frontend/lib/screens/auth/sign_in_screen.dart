import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isFaceIdEnabled = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void handleLogin() {
    // Naviguer directement vers la page d'accueil sans validation
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "VAHANAR",
                        style: GoogleFonts.poppins(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: const Color(0xFF004852),
                        ),
                      ),
                      //IconButton(
                       // icon: Icon(Icons.close, color: Colors.black, size: 24.w),
                        //onPressed: () => Navigator.pop(context),
                     // ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 1.h, height: 0), // Ligne sans espace
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Text(
                    "Sign in",
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 18.sp,
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.grey, size: 20.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    ),
                    style: GoogleFonts.poppins(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 18.sp,
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey, size: 20.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    ),
                    style: GoogleFonts.poppins(fontSize: 16.sp),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                      child: Text(
                        "Forget Password?",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "keep me logged IN ",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 14.sp,
                        ),
                      ),
                      Switch(
                        value: isFaceIdEnabled,
                        onChanged: (value) {
                          setState(() {
                            isFaceIdEnabled = value;
                          });
                        },
                        activeTrackColor: const Color(0xFF2A4D50),
                        activeColor: const Color.fromARGB(255, 255, 255, 255),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey[300],
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Réduire la taille du tap
                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent), // Enlever le bord noir
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    backgroundColor: const Color(0xFF2A4D50),
                  ),
                  onPressed: handleLogin,
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}