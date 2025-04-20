import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isInvalidEmail = false;

  void handleSendEmail() {
    String email = _emailController.text.trim();

    // Vérification que l'email contient le symbole @
    if (!email.contains('@')) {
      setState(() {
        isInvalidEmail = true;
      });
      return;
    }

    // Si l'email est valide, redirige vers la page PassEmailScreen
    setState(() {
      isInvalidEmail = false;
    });
    Navigator.pushNamed(context, '/forgot_password/pass_email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // Titre supprimé de l'AppBar
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Text(
              "Forget password",
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Please enter your email",
              style: GoogleFonts.poppins(
                fontSize: 14.sp, // Taille réduite
                color: Colors.blue, // Couleur changée en bleu
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "yourname@gmail.com",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                prefixIcon: Icon(Icons.email, color: Colors.grey, size: 20.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              style: GoogleFonts.poppins(fontSize: 16.sp),
            ),
            if (isInvalidEmail)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  "Please enter a valid email address.",
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  backgroundColor: const Color(0xFF2A4D50),
                ),
                onPressed: handleSendEmail,
                child: Text(
                  "Send email",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
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