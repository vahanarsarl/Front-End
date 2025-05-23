import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_app/constants.dart';
import 'package:smart_app/widgets/custom_button.dart';
import 'package:smart_app/widgets/bottom_nav_bar.dart';
import 'package:smart_app/screens/home/search_screen.dart';
import 'package:smart_app/screens/home/notifications_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

class CarouselAnimation extends StatefulWidget {
  final List<Widget> items;
  final Function(int)? onPageChanged;

  const CarouselAnimation({required this.items, this.onPageChanged, super.key});

  @override
  _CarouselAnimationState createState() => _CarouselAnimationState();
}

class _CarouselAnimationState extends State<CarouselAnimation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.h,
            autoPlay: false,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            scrollPhysics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(index);
              }
            },
          ),
          items: widget.items,
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> recentSearches = [
    {'title': 'Mohamed V Intl Airport, casab...', 'date': 'Mar 25 – Mar 27'},
    {'title': 'Mohamed V Intl Airport, casab...', 'date': 'Mar 25 – Mar 27'},
    {'title': 'Paris Charles de Gaulle, FRA', 'date': 'Apr 01 – Apr 05'},
    {'title': 'London Heathrow, UK', 'date': 'Apr 10 – Apr 15'},
    {'title': 'New York JFK, USA', 'date': 'Apr 20 – Apr 25'},
    {'title': 'Tokyo Narita, JPN', 'date': 'May 01 – May 05'},
  ];

  List<Map<String, String>> get displayedRecentSearches =>
      recentSearches.length > 5 ? recentSearches.sublist(0, 5) : recentSearches;

  Future<void> _navigateToSearchScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        recentSearches.insert(0, result);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFF004852),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppConstants.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> recentSearchWidgets = displayedRecentSearches.map((item) {
      return _buildRecentSearchCard(item['title']!, item['date']!);
    }).toList();

    final screenWidth = MediaQuery.of(context).size.width;

    List<Widget> rewardCards = [
      _buildRewardCard(
        imagePath: 'assets/animations/earn1.png',
        title: 'Earn points',
        description: 'Earn vahanar points for every valuable dollar you spend and redeem for rewards and accessories',
        screenWidth: screenWidth,
      ),
      _buildRewardCard(
        imagePath: 'assets/animations/earn1.png',
        title: 'Earn points',
        description: 'Earn vahanar points for every valuable dollar you spend and redeem for rewards and accessories',
        screenWidth: screenWidth,
      ),
    ];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15.w).add(EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
                decoration: const BoxDecoration(
                  color: Color(0xFF004852),
                  borderRadius: BorderRadius.zero,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WELCOME',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.sp,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        decorationThickness: 2,
                      ),
                    ),
                    IconButton(
                      icon: Image.asset('assets/icons/not.png'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                        );
                      },
                      tooltip: 'Notifications',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Your Trip',
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: GestureDetector(
                        onTap: () {
                          _navigateToSearchScreen(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/sbl.png', width: 24.w, height: 24.h),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  'Make a reservation',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.w),
                                child: Image.asset('assets/icons/suiv.png', width: 24.w, height: 24.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Recent searches',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 140.h,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          setState(() {
                            _currentCarouselIndex = index;
                          });
                        },
                        children: recentSearchWidgets,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        displayedRecentSearches.length,
                        (index) => Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentCarouselIndex == index
                                ? Colors.black
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      AppConstants.appName.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CarouselAnimation(
                      items: rewardCards,
                      onPageChanged: (index) {
                        setState(() {
                          _currentRewardCarouselIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        rewardCards.length,
                        (index) => Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentRewardCarouselIndex == index
                                ? Colors.black
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h + MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildRecentSearchCard(String title, String date) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            date,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          CustomButton(
            text: 'Continue Reserving',
            onPressed: () {},
            color: Colors.black,
            isLoading: false,
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard({
    required String imagePath,
    required String title,
    required String description,
    required double screenWidth,
  }) {
    return Container(
      width: screenWidth * 0.75,
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: Colors.black,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _currentCarouselIndex = 0;
  int _currentRewardCarouselIndex = 0;
}