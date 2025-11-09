import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shop_core/shop_core.dart';

class BannerCarousel extends StatefulWidget {
  // SỬA: Thay List<String> bằng List<BannerModel>
  final List<BannerModel> banners;
  // THÊM: Callback khi nhấp vào Banner (để xử lý điều hướng ở HomeScreen)
  final Function(BannerModel banner)? onBannerTap;

  const BannerCarousel({
    super.key,
    required this.banners, // <<< CẬP NHẬT CONSTRUCTOR
    this.onBannerTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    // Kiểm tra danh sách có rỗng không
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<BannerModel> banners = widget.banners;

    return Column(
      children: [
        CarouselSlider(
          items:
              banners
                  .map(
                    (banner) => GestureDetector(
                      onTap: () => widget.onBannerTap?.call(banner),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(banner.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 0.9,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              banners.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          // ignore: deprecated_member_use
                          .withOpacity(_current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
