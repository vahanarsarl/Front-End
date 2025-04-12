import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de flutter_screenutil
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vahanar_front/widgets/custom_button.dart';
import 'package:vahanar_front/constants.dart';
import 'package:vahanar_front/providers/auth_provider.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _handleUpdatePassword(AuthProvider authProvider, bool useBackend) async {
    if (useBackend) {
      final success = await authProvider.updatePassword(_passwordController.text.trim());

      if (success) {
        Navigator.pushNamed(context, '/sign_up/step2');
      } else {
        _showError(authProvider.error ?? "Failed to update password");
      }
    } else {
      print('Simulating password update for testing purposes');
      Navigator.pushNamed(context, '/sign_up/step2');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              IconButton(
                icon: Icon(Icons.arrow_back, color: AppConstants.textColor, size: 24.w),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                "Create Password",
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.titleSize.sp ?? 26.sp,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              SizedBox(height: 30.h),
              _buildPasswordField(
                controller: _passwordController,
                hintText: "Create password",
                isVisible: _isPasswordVisible,
                onToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              SizedBox(height: 20.h),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hintText: "Confirm password",
                isVisible: _isConfirmPasswordVisible,
                onToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isChecked = !_isChecked),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        color: _isChecked ? AppConstants.primaryColor : Colors.white,
                      ),
                      child: _isChecked
                          ? Icon(Icons.check, size: 14.w, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "By tapping on Checking this button, you agree to the VAHANAR ",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "privacy policy",
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                          const TextSpan(text: "."),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: "Sign Up",
                onPressed: () => _handleUpdatePassword(authProvider, false),
                color: AppConstants.primaryColor,
                textColor: Colors.white,
                width: double.infinity,
                height: 50.h,
                isLoading: authProvider.isLoading,
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          fontSize: 18.sp,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
            size: 24.w,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}