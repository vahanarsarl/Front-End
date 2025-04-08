import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:vahanar_front/screens/home/home_screen.dart';
import 'package:vahanar_front/screens/home/search_screen.dart';
import 'package:vahanar_front/screens/profile/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex; // Paramètre pour l'index actif

  const BottomNavBar({super.key, this.selectedIndex = 1}); // Par défaut, "Home" est sélectionné

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Initialiser avec l'index passé
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Gérer la navigation en fonction de l'index
    if (index == 0 && ModalRoute.of(context)?.settings.name != '/search') {
      // Naviguer vers SearchScreen si l'utilisateur n'est pas déjà sur cette page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
    } else if (index == 1 && ModalRoute.of(context)?.settings.name != '/home') {
      // Naviguer vers HomeScreen si l'utilisateur n'est pas déjà sur cette page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 2 && ModalRoute.of(context)?.settings.name != '/profile') {
      // Naviguer vers ProfileScreen si l'utilisateur n'est pas déjà sur cette page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color(0xFF004852),
      buttonBackgroundColor: const Color(0xFF004852),
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      index: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        _buildNavItem('search', 0),
        _buildNavItem('home', 1),
        _buildNavItem('person', 2),
      ],
    );
  }

  Widget _buildNavItem(String iconName, int index) {
    bool isSelected = _selectedIndex == index;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isSelected
                ? 'assets/icons/${iconName}_b.png' // Icône blanche si actif
                : 'assets/icons/$iconName.png', // Icône normale sinon
            width: 24,
            height: 24,
            color: isSelected ? Colors.white : const Color(0xFF9DB2CE),
          ),
          const SizedBox(height: 2),
          // Petit indicateur pour l'élément sélectionné
          if (isSelected)
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}