import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/SmoothIndicator/smooth_page_indicator.dart';

// import your cubit and entities
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/widget/SmoothIndicator/scrollig_dots_effect.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../cubit/auction_cubit.dart';
import 'fetch_single_auction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import your cubit and entities
import '../../../../core/enums/base_status_enum.dart';
import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../cubit/auction_cubit.dart';
import 'fetch_single_auction_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import your cubit and entities
import '../../../../core/enums/base_status_enum.dart';
import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../cubit/auction_cubit.dart';
import 'fetch_single_auction_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import your cubit and entities
import '../../../../core/enums/base_status_enum.dart';
import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../cubit/auction_cubit.dart';
import 'fetch_single_auction_screen.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<AuctionCubit>().getAvailableNonSocketAuction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TOP CONTAINER =====
          Container(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.arrow_back_ios, size: 20),
                    SizedBox(width: 8),
                    Text("Auction",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text("(22/1500) Winners",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    SizedBox(width: 6),
                    Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://picsum.photos/400/120",
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          Row(
            // spacing: 10,
            children: [
              SizedBox(
                width: 15,
              ),
              SvgPicture.asset(Assets.searchIcon),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    isScrollable: true,
                    indicator: const BoxDecoration(color: Colors.transparent),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.zero,
                    // Remove default TabBar padding
                    tabs: List.generate(4, (index) {
                      final labels = [
                        LocaleKeys.available.localize,
                        LocaleKeys.expired.localize,
                        LocaleKeys.favorite.localize,
                        LocaleKeys.requestLog.localize
                      ];
                      return AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, _) {
                          final isSelected = _tabController.index == index;
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            // Only 4px space between tabs
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),

          // ===== BUTTON under tabs =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppButton(
              onPressed: () {},
              width: double.infinity,
              backColor: AppColors.cE0E0E0,
              label: LocaleKeys.myAuction.localize,
              style: Styles.mediumText(color: AppColors.black),
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(16),
          //   color: Colors.white,
          //   child: ElevatedButton.icon(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.blue,
          //       foregroundColor: Colors.white,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8)),
          //       padding: const EdgeInsets.symmetric(vertical: 12),
          //       elevation: 0,
          //     ),
          //     onPressed: () {},
          //     icon: const Icon(Icons.add, size: 20),
          //     label: const Text("Add Auction",
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          //   ),
          // ),

          // ===== TAB VIEWS =====
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AvailableAuctionScreen(),
                Center(child: Text("Expired Auctions")),
                Center(child: Text("Favorite Auctions")),
                Center(child: Text("Request Log")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// AVAILABLE TAB
class AvailableAuctionScreen extends StatelessWidget {
  const AvailableAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        final cubit = context.read<AuctionCubit>();
        final auctions = cubit.availableAuctionNonSocketData;

        if (state.status == StateStatus.loading && auctions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == StateStatus.error) {
          return const Center(
              child: Text("Something went wrong",
                  style: TextStyle(color: Colors.red)));
        }

        if (auctions.isEmpty) {
          return const Center(child: Text("No auctions available"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: auctions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final auction = auctions[index];
            return _AuctionCard(auction: auction);
          },
        );
      },
    );
  }
}

// CARD
class _AuctionCard extends StatelessWidget {
  final GetAvailableAuctionEntity auction;

   _AuctionCard({required this.auction});

  String _formatTimeLeft() {
    // Add your time calculation logic here
    return "1h Left"; // placeholder
  }

  String _getParticipantCount() {
    // Add your participant count logic here
    return "120"; // placeholder
  }

  String _getViewCount() {
    // Add your view count logic here
    return "50.7k"; // placeholder
  }

  List<String> images = [
    "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1624555130581-1d9cca783bc0?q=80&w=871&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  ];
  @override
  Widget build(BuildContext context) {
    bool isEnded = auction.status == "ended";

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + heart
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AuctionImageCarousel(
                  images: images,
                  // images: auction.media ?? [],
                ),
              ),
              // Image.network(
              //   auction.media?.first.mediaKey ?? "",
              //   height: 160,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              //   errorBuilder: (_, __, ___) => Container(
              //     height: 160,
              //     color: Colors.grey[200],
              //     child: const Icon(Icons.image, size: 40, color: Colors.grey),
              //   ),
              // ),
              PositionedDirectional(
                top: 12,
                start: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_border,
                      color: Colors.red[400], size: 20),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        auction.title ?? "No Title",
                        style: Styles.mediumText(
                          // fontSize: 18,
                          fontWeight: FontWeight.w700,
                          // height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(text: "Price Now "),
                            TextSpan(
                              text: "${auction.currentPrice ?? 0} ",
                              style: Styles.mediumText(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "EGP",
                              style: Styles.mediumText(
                                fontWeight: FontWeight.w600, // bold
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          style: Styles.mediumText(
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            const TextSpan(text: "Start from "),
                            TextSpan(
                              text: "${auction.startPrice ?? 0} ",
                              style: Styles.mediumText(
                                color: AppColors.black,
                                fontWeight: FontWeight.w400, // lighter
                              ),
                            ),
                            TextSpan(
                              text: "EGP",
                              style: Styles.mediumText(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600, // bold
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        isEnded ? "Ended" : _formatTimeLeft(),
                        style: Styles.mediumText(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Status and stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 👈 Left side
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${_getParticipantCount()} participants",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "${_getViewCount()} views",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 👈 Right side (button) – no Expanded here
                    AppButton(
                      width: 91,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => serviceLocator<AuctionCubit>(),
                              child: SingleAuctionScreen(
                                  auctionId: auction.id ?? ""),
                            ),
                          ),
                        );
                      },
                      label:
                        isEnded ? "Winner" : "Join Now",
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Join button
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class AuctionImageCarousel extends StatefulWidget {
  final List<String> images;

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
                imageUrl,
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

// class _AuctionImageCarouselState extends State<AuctionImageCarousel> {
//   int activeIndex = 0;
//   final CarouselSliderController _controller = CarouselSliderController();
//
// /*
//   Widget _buildCustomDots() {
//     final totalImages = widget.images.length;
//
//     if (totalImages <= 1) return const SizedBox.shrink();
//
//     const mainDots = 4; // number of normal dots before shrinking others
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(totalImages, (index) {
//         final isActive = index == activeIndex;
//
//         double dotSize;
//         Color dotColor;
//
//         if (index < mainDots) {
//           // First 4 dots behave normally
//           if (isActive) {
//             dotSize = 12.0; // active big circle
//             dotColor = context.isDarkMode
//                 ? AppColors.PRIMARY_COLOR_DARK
//                 : AppColors.PRIMARY_COLOR;
//           } else {
//             dotSize = 6.0; // normal inactive dot
//             dotColor = Colors.grey.shade400;
//           }
//         } else {
//           // Remaining dots are tiny unless active
//           if (isActive) {
//             dotSize = 12.0; // grows big when selected
//             dotColor = context.isDarkMode
//                 ? AppColors.PRIMARY_COLOR_DARK
//                 : AppColors.PRIMARY_COLOR;
//           } else {
//             dotSize = 3.0; // very small when not active
//             dotColor = Colors.grey.shade400;
//           }
//         }
//
//         return GestureDetector(
//           onTap: () {
//             _controller.animateToPage(index);
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 250),
//             curve: Curves.easeOut,
//             margin: const EdgeInsets.symmetric(horizontal: 3),
//             width: dotSize,
//             height: dotSize,
//             decoration: BoxDecoration(
//               color: dotColor,
//               shape: BoxShape.circle,
//             ),
//           ),
//         );
//       }),
//     );
//   }
// */
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Column(
//           children: [
//             // ===== IMAGE CAROUSEL =====
//             CarouselSlider.builder(
//               carouselController: _controller,
//               itemCount: widget.images.length,
//               itemBuilder: (context, index, realIndex) {
//                 final imageUrl = widget.images[index];
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     imageUrl ?? "",
//                     // imageUrl.mediaKey ?? "",
//                     height: 201,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 160,
//                       color: Colors.grey[200],
//                       child: const Icon(Icons.image, size: 40, color: Colors.grey),
//                     ),
//                   ),
//                 );
//               },
//               options: CarouselOptions(
//                 height: 201,
//                 viewportFraction: 1,
//                 autoPlay: true,
//                 enableInfiniteScroll: true,
//                 onPageChanged: (index, reason) {
//                   setState(() => activeIndex = index);
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             // ===== CUSTOM DOTS INDICATOR =====
//             _buildCustomDots(),
//           ],
//         ),
//       ],
//     );
//   }
// }


/*
class AuctionImageCarousel extends StatefulWidget {
  final List<AuctionMediaEntity> images;

  const AuctionImageCarousel({super.key, required this.images});

  @override
  State<AuctionImageCarousel> createState() => _AuctionImageCarouselState();
}

class _AuctionImageCarouselState extends State<AuctionImageCarousel> {
  int activeIndex = 0;
  final CarouselSliderController _controller =
      CarouselSliderController(); // ✅ new type

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                    imageUrl.mediaKey ?? "",
                    height: 201,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child:
                          const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 201,
                viewportFraction: 1,
                autoPlay: true,
                // ✅ makes it slide automatically
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() => activeIndex = index);
                },
              ),
            ),

            const SizedBox(height: 8),

            // ===== DOTS INDICATOR =====
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: widget.images.length,
              effect: ScrollingDotsEffect(
                dotHeight: 7,
                // inactive dot height
                dotWidth: 7,
                // inactive dot width
                activeDotScale: 10 / 7,
                // scale active dot from 7 → 10
                spacing: 4,
                // space between dots
                activeDotColor: context.isDarkMode
                    ? AppColors.PRIMARY_COLOR_DARK
                    : AppColors.PRIMARY_COLOR,
                dotColor: Colors.grey.shade300,
              ),
              onDotClicked: (index) {
                _controller.animateToPage(index);
              },
            ),
          ],
        ),

      ],
    );
  }
}

*/