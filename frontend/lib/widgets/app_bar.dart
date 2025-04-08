// lib/widgets/app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final TextStyle? textStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor = Colors.white,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: textStyle ?? TextStyle(
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}