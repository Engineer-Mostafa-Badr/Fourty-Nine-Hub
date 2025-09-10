import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entities/get_all_auction_entity.dart';
import '../../cubit/auction_cubit.dart';
import '../fetch_single_auction_screen.dart';
import 'auction_image_slider.dart';

class AuctionCard extends StatelessWidget {
  final GetAvailableAuctionEntity auction;

  AuctionCard({required this.auction});

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
                    // color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_border,
                      color: Colors.red[400], size: 30),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Flexible(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.visibility,
                                  size: 16,
                                  color: Colors.grey,
                                ),
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

                        ],
                      ),
                    ),

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
