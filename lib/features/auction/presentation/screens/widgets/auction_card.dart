import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:intl/intl.dart';

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
  final bool isFavorite;

  const AuctionCard({
    super.key,
    required this.auction,
    this.isFavorite = false,
  });


  String _formatTimeLeft() {
    final endAt = auction.endAt;
    if (endAt == null) return '';

    final nowUtc = DateTime.now().toUtc();
    final endUtc = endAt.isUtc ? endAt : endAt.toUtc();

    if (endUtc.isBefore(nowUtc)) return 'Ended';

    final diff = endUtc.difference(nowUtc);

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    if (days > 0) {
      if (hours > 0) return '${days}d ${hours}h left';
      return '${days}d left';
    }

    if (hours > 0) {
      if (minutes > 0) return '${hours}h ${minutes}m left';
      return '${hours}h left';
    }

    if (minutes > 0) return '${minutes}m left';
    if (seconds > 0) return '${seconds}s left';

    return 'Less than 1s left';
  }

  String _getParticipantCount() {
    final count = auction.numberOfParticipants ?? 0;
    return NumberFormat.compact().format(count); // e.g. 1K, 2.5K
  }

  String _getViewCount() {
    final count = auction.views ?? 0;
    return NumberFormat.compact().format(count); // e.g. 0, 1, 1K, 50.7K
  }
  String _formatNumber(num? number) {
    if (number == null) return "0";
    return NumberFormat.decimalPattern().format(number);
  }


  @override
  Widget build(BuildContext context) {
    bool isEnded = auction.status == "ended";

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.isDarkMode ? Colors.white : Colors.transparent),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // elevation: 4,

        // color:context.isDarkMode ? Colors.black: Colors.white,
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
                    images: auction.media!,
                    // images: auction.media ?? [],
                  ),
                ),

                PositionedDirectional(
                  top: 12,
                  start: 12,
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuctionCubit>().toggleFavoriteAuction(auction.id ?? "");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        // 👇 if forceFavorite=true → always heart filled
                        isFavorite
                            ? Icons.favorite
                            : (auction.isFavorite == true
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: Colors.red[400],
                        size: 30,
                      ),
                    ),
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
                            color: context.isDarkMode ? Colors.white : Colors.black
                            // height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            style:Styles.mediumText(
                              // fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color:context.isDarkMode ? Colors.white :  Colors.black,
                            ),
                            children: [
                               TextSpan(text:LocaleKeys.priceNow.localize),
                              TextSpan(
                                text: "${_formatNumber(auction.price ?? 0)} ",
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w400,
                                  color: context.isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),

                              TextSpan(
                                text: LocaleKeys.EGP.localize,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w600, // bold
                                  color:context.isDarkMode ? Colors.white :  Colors.black,
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
                              color:context.isDarkMode ? Colors.white :  Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              const TextSpan(text: "Start from "),
                              TextSpan(
                                text: "${auction.price ?? 0} ",
                                style: Styles.mediumText(
                                  color:context.isDarkMode ? Colors.white :  Colors.black,
                                  fontWeight: FontWeight.w400, // lighter
                                ),
                              ),
                              TextSpan(
                                text: "EGP",
                                style: Styles.mediumText(
                                  color:context.isDarkMode ? Colors.white :  Colors.black,
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
                            color:context.isDarkMode ? Colors.white :  Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 👈 Left side (participants + views)
                      Flexible(
                        child: Row(
                          children: [
                            // participants
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
                            const SizedBox(width: 12), // spacing between text + views
                            // views
                            Flexible(
                              child: Row(
                                children: [
                                  const Icon(Icons.visibility, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "${_getViewCount()} views",
                                      style: Styles.mediumText(
                                        color: context.isDarkMode ? Colors.white : Colors.black,
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
                      // 👉 Button on right
                      AppButton(
                        width: 91,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => serviceLocator<AuctionCubit>(),
                                child: SingleAuctionScreen(auctionId: auction.id ?? ""),
                              ),
                            ),
                          );
                        },
                        label: isEnded ? "Winner" : "Join Now",
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
      ),
    );
  }
}
