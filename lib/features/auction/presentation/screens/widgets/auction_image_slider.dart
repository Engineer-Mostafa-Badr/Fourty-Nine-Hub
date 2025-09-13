import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../domain/entities/get_all_auction_entity.dart';

class AuctionImageCarousel extends StatefulWidget {
  final List<AuctionMediaEntity> images;

  const AuctionImageCarousel({super.key, required this.images});

  @override
  State<AuctionImageCarousel> createState() => _AuctionImageCarouselState();
}
class _AuctionImageCarouselState extends State<AuctionImageCarousel> {
  int activeIndex = 0;
  int maxReachedIndex = 0; // track how far user has scrolled
  final CarouselSliderController _controller = CarouselSliderController();

  Widget _buildCustomDots() {
    final totalImages = widget.images.length;

    if (totalImages <= 1) return const SizedBox.shrink();

    const mainDots = 4; // initial normal dots

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalImages, (index) {
        final isActive = index == activeIndex;

        // if user has reached this dot once, promote it to normal
        final isPromoted = index < mainDots || index <= maxReachedIndex;

        double dotSize;
        Color dotColor;

        if (isPromoted) {
          // behaves like a normal dot
          if (isActive) {
            dotSize = 12.0;
            dotColor = context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.PRIMARY_COLOR;
          } else {
            dotSize = 6.0;
            dotColor = Colors.grey.shade400;
          }
        } else {
          // still tiny until visited
          if (isActive) {
            dotSize = 12.0;
            dotColor = context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.PRIMARY_COLOR;
          } else {
            dotSize = 3.0;
            dotColor = Colors.grey.shade400;
          }
        }

        return GestureDetector(
          onTap: () {
            _controller.animateToPage(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ===== IMAGE CAROUSEL =====
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = widget.images[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl.mediaKey!,
                height: 201,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 201,
            viewportFraction: 1,
            autoPlay: true,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
                if (index > maxReachedIndex) {
                  maxReachedIndex = index; // promote dots progressively
                }
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        // ===== CUSTOM DOTS INDICATOR =====
        _buildCustomDots(),
      ],
    );
  }

}