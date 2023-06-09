import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ModelImage extends StatelessWidget {
  final List<String> images;
  final int activeIndex;
  final Function(int, CarouselPageChangedReason)? onPageChanged;

  const ModelImage({
    super.key,
    required this.images,
    required this.activeIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 210.0,
        enlargeCenterPage: true,
        autoPlay: false,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.7,
        onPageChanged: onPageChanged,
      ),
      items: images.map((e) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Image.asset(
            e,
            fit: BoxFit.cover,
            width: 301.0,
          ),
        );
      }).toList(),
    );
  }
}
