import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> banners = [
    "https://i.imgur.com/3cEY3qj.jpeg",
    "https://i.imgur.com/nkN4vX6.jpeg",
    "https://i.imgur.com/RkYx6nH.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MAIN BANNER AREA
        SizedBox(
          height: 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: _controller,
              itemCount: banners.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) {
                return Image.network(
                  banners[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                );
              },
            ),
          ),
        ),

        // LEFT ARROW
        Positioned(
          left: 10,
          top: 55,
          child: _arrowButton(
            Icons.arrow_back_ios_new_rounded,
                () {
              if (_currentPage > 0) {
                _controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),

        // RIGHT ARROW
        Positioned(
          right: 10,
          top: 55,
          child: _arrowButton(
            Icons.arrow_forward_ios_rounded,
                () {
              if (_currentPage < banners.length - 1) {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),

        // PAGE INDICATOR
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 12 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? Colors.white
                      : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white.withOpacity(0.85),
        child: Icon(
          icon,
          size: 18,
          color: BhejduColors.textDark,
        ),
      ),
    );
  }
}
