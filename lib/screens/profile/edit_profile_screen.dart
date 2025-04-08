import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vahanar_front/providers/auth_provider.dart';
import 'package:vahanar_front/widgets/custom_text_field.dart';
import 'package:vahanar_front/widgets/custom_button.dart';
import 'package:vahanar_front/utils/validators.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate(BuildContext context) async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      bool success = await authProvider.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.error ?? 'Failed to update profile')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h), // Augmenter la hauteur pour accueillir le titre en bas
        child: AppBar(
          backgroundColor: const Color(0xFF2A4D50),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h), // Ajuster le padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero, // Réduire le padding par défaut de l'IconButton
                      constraints: const BoxConstraints(), // Supprimer les contraintes par défaut
                    ),
                  ],
                ),
                Text(
                  'EDIT PROFILE',
                  style: GoogleFonts.poppins(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenu des champs de texte
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _firstNameController,
                        icon: Icons.person_outline,
                        hintText: 'First name',
                        validator: Validators.validateFirstName,
                        enabled: !_isLoading,
                        hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                        hintText: 'Last name',
                        validator: Validators.validateLastName,
                        enabled: !_isLoading,
                        hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        controller: _emailController,
                        icon: Icons.email,
                        hintText: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        enabled: false,
                        hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        controller: _phoneController,
                        icon: Icons.phone,
                        hintText: 'Phone number',
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhoneNumber,
                        enabled: !_isLoading,
                        hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bouton "Update Profile" en bas de la page
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: CustomButton(
                  text: _isLoading ? 'Updating...' : 'Update Profile',
                  onPressed: _isLoading ? () {} : () => _handleUpdate(context),
                  color: const Color(0xFF43919D),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}