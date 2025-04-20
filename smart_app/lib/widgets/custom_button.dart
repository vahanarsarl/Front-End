import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color; // Couleur de fond (peut être nulle pour un fond transparent)
  final Color? textColor; // Couleur du texte (peut être définie séparément)
  final BorderSide? borderSide; // Bordure (peut être nulle pour pas de bordure)
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor = Colors.white, // Couleur du texte par défaut : blanc
    this.borderSide,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Désactiver le bouton pendant le chargement
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Utiliser la couleur de fond définie
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            side: borderSide ?? BorderSide.none, // Utiliser la bordure définie
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white) // Afficher un indicateur de chargement
            : Text(
                text,
                style: textStyle ??
                    TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.bold,
                      color: textColor, // Utiliser la couleur du texte définie
                    ),
              ),
      ),
    );
  }
}