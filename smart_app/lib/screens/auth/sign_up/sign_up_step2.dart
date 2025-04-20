import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de flutter_screenutil
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_app/widgets/custom_button.dart';
import 'package:smart_app/constants.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    print('Verifying OTP and navigating to /sign_up/finish');
    Navigator.pushNamed(context, '/sign_up/finish');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //children: [
                  //IconButton(
                   // icon: Icon(Icons.arrow_back, color: AppConstants.textColor, size: 24.w),
                   // onPressed: () => Navigator.pop(context),
                  //),
                 // SizedBox(width: 16.w),
                //],
              ),
              SizedBox(height: 20.h),
              Text(
                "Verify your phone number",
                style: GoogleFonts.poppins(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  text: "We've sent an SMS with an activation code to your phone ",
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 16.sp,
                  ),
                  children: [
                    TextSpan(
                      text: "+212 7  ** ** 99",
                      style: GoogleFonts.poppins(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Center(
                child: PinCodeTextField(
                  appContext: context,
                  length: 5,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8.r),
                    fieldHeight: 50.h,
                    fieldWidth: 45.w,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.grey.shade200,
                    selectedFillColor: Colors.white,
                    activeColor: AppConstants.primaryColor,
                    inactiveColor: Colors.grey.shade400,
                    selectedColor: AppConstants.primaryColor,
                  ),
                  cursorColor: AppConstants.primaryColor,
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "I didn’t receive a code ",
                    style: GoogleFonts.poppins(
                      color: Colors.black45,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: "Resend",
                        style: GoogleFonts.poppins(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                text: "Verify",
                onPressed: () => _handleVerify(),
                color: AppConstants.primaryColor,
                width: double.infinity,
                height: 50.h,
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white,
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