import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final IconData? icon; // Rendre icon optionnel
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const CustomTextField({
    super.key,
    this.icon, // Plus obligatoire
    required this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.hintStyle,
    required this.enabled,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null, // Afficher l'icône seulement si elle est fournie
          hintText: hintText,
          hintStyle: hintStyle ?? GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
          errorText: errorText,
        ),
      ),
    );
  }
}