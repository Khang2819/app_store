import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:shop_core/shop_core.dart';

class Imagecarousel extends StatefulWidget {
  const Imagecarousel({super.key, required this.product});
  final Product product;

  @override
  State<Imagecarousel> createState() => _ImagecarouselState();
}

class _ImagecarouselState extends State<Imagecarousel> {
  int _currentImageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      widget.product.imageUrl,
      widget.product.imageUrl,
      widget.product.imageUrl,
    ];
    return Stack(
      children: [
        CarouselSlider(
          items:
              images
                  .map(
                    (item) => Container(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 120,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                images.asMap().entries.map((entry) {
                  final bool isActive = _currentImageIndex == entry.key;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 20 : 8, // khi active sẽ dẹt dài hơn
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white54 : Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
