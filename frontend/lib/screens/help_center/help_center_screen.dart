import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ajout de FlutterScreenUtil
import 'package:google_fonts/google_fonts.dart'; // Ajout de GoogleFonts pour Poppins
import 'package:vahanar_front/widgets/bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart'; // Ajout de url_launcher pour les liens

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  bool _showFAQ = true;
  int? _expandedIndex;

  // Fonction pour lancer les URLs
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header personnalisé
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              color: const Color(0xFF2A4D50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Text(
                    'HELP CENTER',
                    style: GoogleFonts.poppins( // Remplacement par Poppins
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Barre de recherche
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/sbl.png', // Remplacement de l'icône de recherche
                      width: 24.w,
                      height: 24.h,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by topic',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/suiv.png', // Remplacement de l'icône de flèche
                      width: 24.w,
                      height: 24.h,
                    ),
                  ],
                ),
              ),
            ),
            // Boutons FAQ et Contact Us
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showFAQ = true;
                          _expandedIndex = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showFAQ ? const Color(0xFF2A4D50) : Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'FAQ',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showFAQ = false;
                          _expandedIndex = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_showFAQ ? const Color(0xFF2A4D50) : Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'CONTACT US',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Contenu conditionnel : FAQ ou Contact Us
            Expanded(
              child: _showFAQ ? _buildFAQContent() : _buildContactUsContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }

  // Contenu FAQ
  Widget _buildFAQContent() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.w,
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          child: ExpansionTile(
            initiallyExpanded: index == _expandedIndex,
            title: Text(
              'Lorem ipsum dolor sit amet?',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.expand_more,
              color: const Color(0xFF2A4D50),
              size: 24.w,
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() {
                if (expanded) {
                  _expandedIndex = index;
                } else {
                  _expandedIndex = null;
                }
              });
            },
          ),
        );
      },
    );
  }

  // Contenu Contact Us
  Widget _buildContactUsContent() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 5, // 5 éléments : LinkedIn, Website, X (Twitter), Facebook, Instagram
      itemBuilder: (context, index) {
        return _buildContactItem(index);
      },
    );
  }

  // Méthode pour les éléments de Contact Us
  Widget _buildContactItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ExpansionTile(
        initiallyExpanded: index == _expandedIndex,
        leading: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Image.asset(
            'assets/icons/${_getContactIconName(index)}.png',
            width: 24.w,
            height: 24.h,
            color: const Color(0xFF2A4D50),
          ),
        ),
        title: Text(
          _getContactTitle(index),
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.expand_more,
          color: const Color(0xFF2A4D50),
          size: 24.w,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: GestureDetector(
              onTap: () {
                final url = _getContactUrl(index);
                if (url.isNotEmpty) {
                  _launchURL(url);
                }
              },
              child: Text(
                _getContactUrl(index).isNotEmpty ? 'Visit ${_getContactTitle(index)}' : 'Coming soon',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: _getContactUrl(index).isNotEmpty ? Colors.blue : Colors.grey,
                  decoration: _getContactUrl(index).isNotEmpty ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            if (expanded) {
              _expandedIndex = index;
            } else {
              _expandedIndex = null;
            }
          });
        },
      ),
    );
  }

  String _getContactIconName(int index) {
    switch (index) {
      case 0:
        return 'eclipse1'; // LinkedIn
      case 1:
        return 'eclipse2'; // Website
      case 2:
        return 'eclipse3'; // X (Twitter)
      case 3:
        return 'eclipse4'; // Facebook
      case 4:
        return 'eclipse5'; // Instagram
      default:
        return 'error';
    }
  }

  String _getContactTitle(int index) {
    switch (index) {
      case 0:
        return 'LinkedIn';
      case 1:
        return 'Website';
      case 2:
        return 'X (Twitter)';
      case 3:
        return 'Facebook';
      case 4:
        return 'Instagram';
      default:
        return 'Unknown';
    }
  }

  String _getContactUrl(int index) {
    switch (index) {
      case 0:
        return 'https://www.linkedin.com/company/vahanar/'; // LinkedIn
      case 1:
        return ''; // Website (vide pour l'instant)
      case 2:
        return 'https://x.com/Vahanar_'; // X (Twitter)
      case 3:
        return 'https://web.facebook.com/people/Vahanar/61574664671787/?rdid=Owm8mwpughqdkltf&share_url=https%3A%2F%2Fweb.facebook.com%2Fshare%2F1X6WbDTKUb%2F%3F_rdc%3D1%26_rdr'; // Facebook
      case 4:
        return 'https://www.instagram.com/vahanar_/'; // Instagram
      default:
        return '';
    }
  }
}