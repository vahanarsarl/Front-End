import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselAnimation extends StatefulWidget {
  final List<Widget> items;
  final Function(int)? onPageChanged; // Callback pour suivre l'index

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
            height: 200,
            autoPlay: true,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
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
        const SizedBox(height: 10),
        // Indicateur de page (facultatif, géré dans home_screen.dart)
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.blue
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          }).toList(),
        ),*/
      ],
    );
  }
}