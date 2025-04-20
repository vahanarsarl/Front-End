import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de flutter_screenutil
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_app/widgets/custom_text_field.dart';
import 'package:smart_app/widgets/custom_button.dart';
import 'package:smart_app/constants.dart';

class SignInLink extends StatelessWidget {
  final bool isLoading;
  const SignInLink({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "You have account? ",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 14.sp,
          ),
        ),
        GestureDetector(
          onTap: isLoading ? null : () => Navigator.pushNamed(context, '/sign_in'),
          child: Text(
            "Sign in",
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class SignUpStep1Screen extends StatefulWidget {
  const SignUpStep1Screen({super.key});

  @override
  _SignUpStep1ScreenState createState() => _SignUpStep1ScreenState();
}

class _SignUpStep1ScreenState extends State<SignUpStep1Screen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final permissionStatus = await Permission.photos.request();
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission to access gallery is required", style: TextStyle(fontSize: 14.sp))),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp(BuildContext context) async {
    print('Starting _handleSignUp');
    setState(() => _isLoading = true);

    print('Navigating to /sign_up/create_password');
    Navigator.pushNamed(context, '/sign_up/create_password');

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "VAHANAR",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF004852),
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black, size: 24.w),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: Colors.grey,
            height: 1.h,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.10.sh),
                Text(
                  "SIGN UP",
                  style: GoogleFonts.poppins(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                SizedBox(height: 40.h),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                                size: 40.w,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _isLoading ? null : _pickImage,
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4.r,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.grey,
                              size: 24.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  controller: _firstNameController,
                  icon: Icons.person_outline,
                  hintText: "First name",
                  enabled: !_isLoading,
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  controller: _lastNameController,
                  icon: Icons.person_outline,
                  hintText: "Last name",
                  enabled: !_isLoading,
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  controller: _emailController,
                  icon: Icons.email,
                  hintText: "Email address",
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  controller: _phoneController,
                  icon: Icons.phone,
                  hintText: "Phone number",
                  keyboardType: TextInputType.phone,
                  enabled: !_isLoading,
                  hintStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 0.15.sh),
                CustomButton(
                  text: _isLoading ? "Signing Up..." : "SIGN UP",
                  onPressed: _isLoading ? () {} : () => _handleSignUp(context),
                  color: AppConstants.primaryColor,
                  width: double.infinity,
                  height: 50.h,
                  borderRadius: BorderRadius.circular(10.r),
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  isLoading: _isLoading,
                ),
                SizedBox(height: 16.h),
                SignInLink(isLoading: _isLoading),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}