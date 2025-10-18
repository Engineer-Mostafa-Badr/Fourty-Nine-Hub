import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/last_viewers_widget.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/show_winner_widget.dart';
import 'package:fourtyninehub/features/auction/presentation/screens/widgets/winner_overlay_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entities/get_all_auction_entity.dart';
import '../../../domain/entities/listen_winner_bid_entity.dart';
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
      margin: EdgeInsets.all(8),
      child: GlobalCard(
        subcategoryId: '',
        phone: '',
        reportId: '',
        otherUserId: '',
        onTap: () {
          },
        hasTopSide: true,
        hasBottomSide: false,
        subscriptionType: LocaleKeys.notSubscribed.localize,
        views: auction.views,
        onRequest: (){
      
        },
        onShowViewers: () async {
          final cubit = context.read<AuctionCubit>();

          // Fetch viewers first
          if((auction.views??0)>0){
            await cubit.fetchViewerEntity(id: auction.id!);

            final viewers = cubit.state.auctionViewerData;

            if (viewers != null && viewers.isNotEmpty) {
              showModalBottomSheet(
                backgroundColor: context.isDarkMode
                    ? AppColors.DARK_BLUE_COLOR
                    .withOpacity(0.95)
                    : AppColors.LIGHT_COLOR,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.32,
                ),
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                isDismissible: true,
                // isScrollControlled: true,
                builder: (BuildContext context) {
                  return LastViewersWidget(lastViewers: viewers,);
                },
              );
            } else {
              // Handle empty viewers or error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic
                        ? 'لا يوجد مشاهدون متاحون'
                        : 'No viewers available',
                  ),
                ),
              );

            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.isArabic
                      ? 'لا يوجد مشاهدون متاحون'
                      : 'No viewers available',
                ),
              ),
            );

          }

        },


        onSubscribe: (){
          context.pop();
        },
        body:Column(
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
                      if(auction.id != null){
                        context.read<AuctionCubit>().toggleFavoriteAuction(auction.id ?? "");
                      }else{
                        showErrorMessage(context, "${context.isArabic ? "حدث خطا ما":"Error happen"}");
                      }
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          ],
                        ),
                      ),
                      // AppButton(
                      //   width: 91,
                      //   backColor: (auction.status == "expired" || auction.status == "pending")
                      //       ? AppColors.grey // grey out if expired or pending
                      //       : auction.isWinner == true
                      //       ? AppColors.cFFAC3F
                      //       : AppColors.PRIMARY_COLOR_DARK,
                      //   onPressed: (auction.status == "expired" || auction.status == "pending")
                      //       ? (){} // 👈 null disables the button completely
                      //       : () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => BlocProvider(
                      //           create: (_) => serviceLocator<AuctionCubit>(),
                      //           child: SingleAuctionScreen(
                      //             auctionId: auction.id ?? "",
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   style: Styles.mediumText(
                      //     color: (auction.status == "expired" || auction.status == "pending")
                      //         ? AppColors.grey.shade700
                      //         : auction.isWinner == true
                      //         ? AppColors.black
                      //         : AppColors.whiteColor,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   // label: auction.status == "expired"
                      //   //     ? LocaleKeys.expired.localize
                      //   //     : auction.status == "pending"
                      //   //     ? LocaleKeys.pending.localize
                      //   //     : auction.isWinner == true
                      //   //     ? LocaleKeys.winnerAuction.localize
                      //   //     : LocaleKeys.joinNow.localize,
                      //   label: auction.status == "expired"
                      //       ? LocaleKeys.expired.localize
                      //       : auction.status == "pending"
                      //       ? LocaleKeys.pending.localize
                      //       : auction.isWinner == true
                      //       ? LocaleKeys.winnerAuction.localize
                      //       : LocaleKeys.joinNow.localize,
                      // ),
/*
                      AppButton(
                        width: 91,
                        backColor: auction.isWinner == true
                            ? AppColors.cFFAC3F // 🟧 Winner color
                            : (auction.status == "expired" || auction.status == "pending")
                            ? AppColors.grey
                            : AppColors.PRIMARY_COLOR_DARK,

                        onPressed: (auction.status == "expired" || auction.status == "pending")
                            ? () {}
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
                          color: auction.isWinner == true
                              ? AppColors.black
                              : (auction.status == "expired" || auction.status == "pending")
                              ? AppColors.grey.shade700
                              : AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),

                        label: auction.isWinner == true
                            ? LocaleKeys.winnerAuction.localize // 🏆 Winner text
                            : auction.status == "expired"
                            ? LocaleKeys.expired.localize
                            : auction.status == "pending"
                            ? LocaleKeys.pending.localize
                            : LocaleKeys.joinNow.localize,
                      )
*/
                      AppButton(
                        width: 91,
                        backColor: auction.isWinner == true
                            ? AppColors.cFFAC3F
                            : (auction.status == "expired" || auction.status == "pending")
                            ? AppColors.grey
                            : AppColors.PRIMARY_COLOR_DARK,
                        onPressed: () {
                          // Only proceed if not pending
                          if (auction.status != "pending") {
                            if (auction.winnerData != null) {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'WinnerOverlay',
                                barrierColor: Colors.black54, // optional: slight background dim
                                transitionDuration: const Duration(milliseconds: 200),
                                pageBuilder: (context, _, __) {
                                  return WinnerOverlayWidget(
                                    winner: auction.winnerData!,
                                    onClose: () {
                                      Navigator.of(context).pop(); // close overlay
                                    },
                                  );
                                },
                                transitionBuilder: (context, animation, secondaryAnimation, child) {
                                  // optional: fade + scale animation
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: Tween(begin: 0.95, end: 1.0).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                              );
                            } else if (auction.status != "expired" && auction.status != "winner") {
                              // If no winnerData and not expired/winner, navigate to auction
                              if(auction.status == "available")
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
                            }
                          }
                        },
                        style: Styles.mediumText(
                          color: auction.isWinner == true
                              ? AppColors.black
                              : (auction.status == "expired" || auction.status == "pending")
                              ? AppColors.grey.shade700
                              : AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                        label: auction.isWinner == true
                            ? LocaleKeys.winnerAuction.localize
                            : auction.status == "expired"
                            ? LocaleKeys.expired.localize
                            : auction.status == "pending"
                            ? LocaleKeys.pending.localize
                            : LocaleKeys.joinNow.localize,
                      )




                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
