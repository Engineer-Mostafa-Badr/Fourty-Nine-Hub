import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  String _formatTimeLeft(BuildContext context) {
    final endAt = auction.endAt;
    if (endAt == null) return '';

    final nowUtc = DateTime.now().toUtc();
    final endUtc = endAt.isUtc ? endAt : endAt.toUtc();

    if (endUtc.isBefore(nowUtc)) {
      return context.isArabic ? 'انتهى' : 'Ended';
    }

    final diff = endUtc.difference(nowUtc);

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    String format(num number) => _formatNumber(context, number);

    if (days > 0) {
      if (hours > 0) {
        return context.isArabic
            ? '${format(days)} يوم ${format(hours)} ساعة متبقية'
            : '${format(days)}d ${format(hours)}h left';
      }
      return context.isArabic
          ? '${format(days)} يوم متبقي'
          : '${format(days)}d left';
    }

    if (hours > 0) {
      if (minutes > 0) {
        return context.isArabic
            ? '${format(hours)} ساعة ${format(minutes)} دقيقة متبقية'
            : '${format(hours)}h ${format(minutes)}m left';
      }
      return context.isArabic
          ? '${format(hours)} ساعة متبقية'
          : '${format(hours)}h left';
    }

    if (minutes > 0) {
      return context.isArabic
          ? '${format(minutes)} دقيقة متبقية'
          : '${format(minutes)}m left';
    }

    if (seconds > 0) {
      return context.isArabic
          ? '${format(seconds)} ثانية متبقية'
          : '${format(seconds)}s left';
    }

    return context.isArabic
        ? 'أقل من ثانية متبقية'
        : 'Less than 1s left';
  }



  String _formatNumber(BuildContext context, num? number) {
    if (number == null) return "0";

    final locale = context.isArabic ? 'ar' : 'en';
    final formatter = NumberFormat.decimalPattern(locale);
    String formatted = formatter.format(number);

    if (context.isArabic) {
      const english = ['0','1','2','3','4','5','6','7','8','9'];
      const arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

      for (int i = 0; i < english.length; i++) {
        formatted = formatted.replaceAll(english[i], arabic[i]);
      }
    }

    return formatted;
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
                    images: auction.media ?? [], // ✅ use empty list if null
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
                          auction.title ?? "",
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
                                text: " ${_formatNumber(context,auction.lastPrice ?? 0,)} ",
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.bold
                                )
                                // TextStyle(
                                //   fontSize: 30.sp,
                                //   fontWeight: FontWeight.w400,
                                //   color: Color(0xff0B1035),
                                // ),

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
                               TextSpan(text: LocaleKeys.startFrom.localize),
                              TextSpan(
                                // child: SizedBox(
                                //   width: 60,
                                //   child: AutoSizeText(
                                //     " ${_formatNumber(context,auction.price ?? 0)} ",
                                //     style: Styles.mediumText(
                                //       fontWeight: FontWeight.bold,
                                //       color: context.isDarkMode ? Colors.white : Colors.black,
                                //     ),
                                //   ),
                                // ),
                                text: " ${_formatNumber(context,auction.price ?? 0)} ",
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.bold,
                                  color: context.isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: LocaleKeys.EGP.localize,
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
                          isEnded ? "${LocaleKeys.ended.localize}" : _formatTimeLeft(context
                          ),
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
                                "${_formatNumber(context, auction.numberOfParticipants ?? 0)} ${LocaleKeys.participants.localize}",
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
                                      "${_formatNumber(context, auction.views ?? 0)} ${LocaleKeys.views.localize}",
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
                      AppButton(
                        width: 91,
                        backColor: (auction.status == "expired" || auction.status == "pending")
                            ? AppColors.grey // grey out if expired or pending
                            : auction.isWinner == true
                            ? AppColors.cFFAC3F
                            : AppColors.PRIMARY_COLOR_DARK,
                        onPressed: (auction.status == "expired" || auction.status == "pending")
                            ? (){} // 👈 null disables the button completely
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => serviceLocator<AuctionCubit>(),
                                child: SingleAuctionScreen(
                                  auctionId: auction.id ?? "",
                                ),
                              ),
                            ),
                          );
                        },
                        style: Styles.mediumText(
                          color: (auction.status == "expired" || auction.status == "pending")
                              ? AppColors.grey.shade700
                              : auction.isWinner == true
                              ? AppColors.black
                              : AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        label: auction.status == "expired"
                            ? LocaleKeys.expired.localize
                            : auction.status == "pending"
                            ? LocaleKeys.pending.localize
                            : auction.isWinner == true
                            ? LocaleKeys.winnerAuction.localize
                            : LocaleKeys.joinNow.localize,
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
